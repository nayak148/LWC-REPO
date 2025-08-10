import { LightningElement,api , track } from 'lwc';
export default class DocumentUploadPreview extends LightningElement {
    @api recordId;
    @track uploadedFiles = [];
    acceptedFormats = ['.pdf', '.doc', '.docx'];

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        this.uploadedFiles = uploadedFiles.map(file => ({
            Id: file.documentId,
            Title: file.name,
            ContentDownloadUrl: `/sfc/servlet.shepherd/document/download/${file.documentId}`
        }));
    }
}