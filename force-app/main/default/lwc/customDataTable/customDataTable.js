import { LightningElement, api, track } from 'lwc';

const DEFAULT_PAGE_SIZE = 10;

export default class CustomDataTable extends LightningElement {
    // Public API
    @api keyField = 'id';
    @api selectable = false;
    @api showRowNumber = false;
    @api enablePagination = true;

    _columns = [];
    _data = [];

    @api
    get columns() {
        return this._columns;
    }
    set columns(value) {
        this._columns = Array.isArray(value) ? value.map((c) => ({ ...c })) : [];
        this._normalizeColumns();
        this._recompute();
    }

    @api
    get data() {
        return this._data;
    }
    set data(value) {
        this._data = Array.isArray(value) ? value.map((r) => ({ ...r })) : [];
        this.totalRows = this._data.length;
        this._recompute();
    }

    // Sorting API
    @api sortedBy;
    @api sortedDirection = 'asc'; // 'asc' | 'desc'

    // Pagination
    @track pageNumber = 1;
    @api pageSize = DEFAULT_PAGE_SIZE;

    // Internal state
    @track renderRows = [];
    @track totalRows = 0;

    selectedKeySet = new Set();

    get hasRows() {
        return this.totalRows > 0;
    }

    get colSpan() {
        let span = this.displayColumns.length;
        if (this.selectable) span += 1;
        if (this.showRowNumber) span += 1;
        return Math.max(span, 1);
    }

    get displayColumns() {
        return (this._columns || []).map((c) => ({
            ...c,
            isSorted: c.fieldName === this.sortedBy,
            sortClass:
                c.fieldName === this.sortedBy
                    ? this.sortedDirection === 'asc'
                        ? 'sort-indicator sort-asc'
                        : 'sort-indicator sort-desc'
                    : 'sort-indicator'
        }));
    }

    get pageCount() {
        if (!this.enablePagination) {
            return 1;
        }
        const total = this.totalRows || 0;
        const size = Math.max(1, Number(this.pageSize) || DEFAULT_PAGE_SIZE);
        return Math.max(1, Math.ceil(total / size));
    }

    get isFirstPage() {
        return this.pageNumber <= 1;
    }

    get isLastPage() {
        return this.pageNumber >= this.pageCount;
    }

    get pageStart() {
        if (!this.hasRows) return 0;
        const size = this._effectivePageSize();
        return (this.pageNumber - 1) * size + 1;
    }

    get pageEnd() {
        if (!this.hasRows) return 0;
        const size = this._effectivePageSize();
        return Math.min(this.pageNumber * size, this.totalRows);
    }

    get isPageAllSelected() {
        if (!this.selectable || !this.renderRows || this.renderRows.length === 0) return false;
        return this.renderRows.every((r) => r.selected);
    }

    // Event handlers
    handleHeaderClick(event) {
        const field = event.currentTarget?.dataset?.field;
        if (!field) return;

        let nextDirection = 'asc';
        if (this.sortedBy === field) {
            nextDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc';
        }

        this.sortedBy = field;
        this.sortedDirection = nextDirection;

        this.dispatchEvent(
            new CustomEvent('sort', {
                detail: { sortedBy: this.sortedBy, sortedDirection: this.sortedDirection }
            })
        );

        this._recompute();
    }

    handleToggleRow(event) {
        const key = event.currentTarget?.dataset?.key;
        if (!key) return;
        if (event.target.checked) {
            this.selectedKeySet.add(key);
        } else {
            this.selectedKeySet.delete(key);
        }
        this._markSelectionOnPage();
        this._emitSelectionChange();
    }

    handleToggleSelectAll(event) {
        const check = event.target.checked;
        for (const row of this.renderRows) {
            if (check) {
                this.selectedKeySet.add(row.key);
            } else {
                this.selectedKeySet.delete(row.key);
            }
        }
        this._markSelectionOnPage();
        this._emitSelectionChange();
    }

    handleFirstPage() {
        if (!this.enablePagination) return;
        this.pageNumber = 1;
        this._recompute();
    }

    handlePrevPage() {
        if (!this.enablePagination) return;
        this.pageNumber = Math.max(1, this.pageNumber - 1);
        this._recompute();
    }

    handleNextPage() {
        if (!this.enablePagination) return;
        this.pageNumber = Math.min(this.pageCount, this.pageNumber + 1);
        this._recompute();
    }

    handleLastPage() {
        if (!this.enablePagination) return;
        this.pageNumber = this.pageCount;
        this._recompute();
    }

    // Public selection API
    @api
    getSelectedKeys() {
        return Array.from(this.selectedKeySet);
    }

    @api
    getSelectedRows() {
        const keys = this.getSelectedKeys();
        const keyField = this.keyField;
        return (this._data || []).filter((r) => keys.includes(String(r[keyField])));
    }

    @api
    resetSelection() {
        this.selectedKeySet.clear();
        this._markSelectionOnPage();
        this._emitSelectionChange();
    }

    // Internals
    _effectivePageSize() {
        if (!this.enablePagination) return this.totalRows || 0;
        const size = Number(this.pageSize) || DEFAULT_PAGE_SIZE;
        return Math.max(1, size);
    }

    _normalizeColumns() {
        this._columns = (this._columns || []).map((c) => {
            const type = c.type || 'text';
            const alignment = c.alignment || (type === 'number' || type === 'currency' || type === 'percent' ? 'right' : 'left');
            const headerClass = `th ${c.sortable ? 'th-sortable' : ''}`;
            const cellClass = `td align-${alignment}${c.cellClass ? ' ' + c.cellClass : ''}`;
            return {
                label: c.label ?? c.fieldName,
                fieldName: c.fieldName,
                type,
                sortable: c.sortable === true,
                disableSort: c.sortable !== true,
                alignment,
                headerClass,
                headerStyle: c.width ? `min-width:${c.width};width:${c.width};` : undefined,
                cellClass,
                cellStyle: c.width ? `min-width:${c.width};width:${c.width};` : undefined,
                urlLabelField: c.urlLabelField // only for type=url
            };
        });
    }

    _recompute() {
        const sorted = this._sortData(this._data, this.sortedBy, this.sortedDirection);
        const pageRows = this._slicePage(sorted);
        this.renderRows = this._prepareRows(pageRows);
        this._markSelectionOnPage();
    }

    _sortData(rows, sortedBy, sortedDirection) {
        const data = Array.isArray(rows) ? [...rows] : [];
        if (!sortedBy) return data;

        const direction = sortedDirection === 'desc' ? -1 : 1;
        return data.sort((a, b) => {
            const av = a?.[sortedBy];
            const bv = b?.[sortedBy];

            // Handle undefined/null
            if (av == null && bv == null) return 0;
            if (av == null) return -1 * direction;
            if (bv == null) return 1 * direction;

            // Compare numbers/dates/strings
            if (typeof av === 'number' && typeof bv === 'number') {
                return (av - bv) * direction;
            }

            const ad = av instanceof Date ? av.getTime() : Date.parse(av);
            const bd = bv instanceof Date ? bv.getTime() : Date.parse(bv);
            if (!Number.isNaN(ad) && !Number.isNaN(bd)) {
                return (ad - bd) * direction;
            }

            const as = String(av).toLowerCase();
            const bs = String(bv).toLowerCase();
            if (as < bs) return -1 * direction;
            if (as > bs) return 1 * direction;
            return 0;
        });
    }

    _slicePage(rows) {
        if (!this.enablePagination) return rows;
        const size = this._effectivePageSize();
        const total = rows.length;
        const maxPage = Math.max(1, Math.ceil(total / size));
        if (this.pageNumber > maxPage) {
            this.pageNumber = maxPage;
        }
        const start = (this.pageNumber - 1) * size;
        const end = Math.min(start + size, total);
        return rows.slice(start, end);
    }

    _prepareRows(rows) {
        const keyField = this.keyField;
        const cols = this._columns || [];
        let rowIndex = this.pageStart; // 1-based row number across dataset
        return rows.map((r) => {
            const key = String(r?.[keyField]);
            const cells = cols.map((c) => this._prepareCell(r, c));
            const row = {
                key,
                selected: this.selectedKeySet.has(key),
                cells,
                rowNumber: this.showRowNumber ? rowIndex : undefined
            };
            rowIndex += 1;
            return row;
        });
    }

    _prepareCell(row, col) {
        const raw = row?.[col.fieldName];
        const type = col.type || 'text';
        let display = '';
        let isUrl = false;
        let href;

        switch (type) {
            case 'number':
                display = raw == null || raw === '' ? '' : new Intl.NumberFormat().format(Number(raw));
                break;
            case 'currency':
                display = raw == null || raw === '' ? '' : new Intl.NumberFormat(undefined, { style: 'currency', currency: 'USD' }).format(Number(raw));
                break;
            case 'percent':
                display = raw == null || raw === '' ? '' : `${Number(raw)}%`;
                break;
            case 'date':
                if (raw == null || raw === '') {
                    display = '';
                } else {
                    const dt = raw instanceof Date ? raw : new Date(raw);
                    display = new Intl.DateTimeFormat(undefined, { year: 'numeric', month: 'short', day: '2-digit' }).format(dt);
                }
                break;
            case 'url':
                isUrl = true;
                href = raw || '#';
                if (col.urlLabelField && row?.[col.urlLabelField]) {
                    display = String(row[col.urlLabelField]);
                } else {
                    display = raw ? String(raw) : '';
                }
                break;
            default:
                display = raw == null ? '' : String(raw);
        }

        return {
            key: `${col.fieldName}`,
            raw,
            display,
            isUrl,
            href,
            cellClass: col.cellClass,
            cellStyle: col.cellStyle
        };
    }

    _markSelectionOnPage() {
        if (!Array.isArray(this.renderRows)) return;
        for (const row of this.renderRows) {
            row.selected = this.selectedKeySet.has(row.key);
        }
    }

    _emitSelectionChange() {
        this.dispatchEvent(
            new CustomEvent('selectionchange', {
                detail: {
                    selectedKeys: this.getSelectedKeys(),
                    selectedRows: this.getSelectedRows()
                }
            })
        );
    }
}