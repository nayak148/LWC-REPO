import { LightningElement } from 'lwc';
export default class Emailsignature extends LightningElement {
  
  updateUserDetails() {
    const fontStyle = "font-family: Aptos, Aptos_EmbeddedFont, Aptos_MSFontService, Calibri, Helvetica, sans-serif; color: rgb(0, 0, 0);";
    const smallText = "font-size: 8pt;";
    const mediumText = "font-size: 9pt;";
    const largeText = "font-size: 10pt;";

    let titleSection = this.title && this.title !== "null" ? 
        `<b><span style="${fontStyle} ${mediumText}">${this.title}</span></b><br>` : '';

    let departmentdata = this.userdepartment ? 
        `<b><span style="${fontStyle} ${mediumText}">${this.userdepartment}</span></b><br>` : '';

    let phoneNumberHTML = '';
    if (this.phone) phoneNumberHTML += `<b style="${fontStyle} ${mediumText}">D: ${this.phone}</b>`;
    if (this.mobilephone) phoneNumberHTML += phoneNumberHTML ? ' / ' : '';
    if (this.mobilephone) phoneNumberHTML += `<b style="${fontStyle} ${mediumText}">M: ${this.mobilephone}</b>`;
    if (this.fax) phoneNumberHTML += phoneNumberHTML ? ' / ' : '';
    if (this.fax) phoneNumberHTML += `<b style="${fontStyle} ${mediumText}">F: ${this.fax}</b>`;
    phoneNumberHTML = phoneNumberHTML ? phoneNumberHTML + '<br>' : '';

    let nameHtml = `${this.firstName || ''} ${this.middleName || ''} ${this.lastName || ''}`.trim();
    nameHtml = nameHtml ? `<b><span style="${fontStyle} ${largeText}">${nameHtml}</span></b><br>` : '';

    let addressHTML = [this.street, this.city, this.state, this.postalcode, this.country]
        .filter(Boolean)
        .join(', ');
    addressHTML = addressHTML ? `<span style="${fontStyle} ${smallText}">${addressHTML}.</span><br>` : '';

    this.sign = `
        <br><br><br><br><br>
        <div id="Signature" class="elementToProof">
            <table style="width: auto; box-sizing: border-box; border-collapse: collapse; border-spacing: 0px;" id="table_0">
                <tbody>
                    <tr>
                        <td style="border-right: 1pt solid windowtext; padding-right: 2.25pt; padding-left: 2.25pt; width: auto; height: auto;">
                            <p align="center" style="margin: 5pt 0px 0px; ${fontStyle} font-size: 11pt;">
                                <img src="https://amity.edu/noida/img/logo.png" 
                                     alt="logo 2" 
                                     style="width: 210px; height: auto;">
                            </p>
                        </td>
                        <td style="padding-right: 5pt; padding-left: 5.4pt; width: auto; height: auto;">
                            <p style="margin: 0px; ${fontStyle} font-size: 11pt;">
                                <span style="${fontStyle} ${smallText} color: rgb(31, 65, 143);">
                                    ${nameHtml}
                                    ${titleSection}
                                    <b>LISCR, LLC</b><br>
                                    ${addressHTML}
                                    ${phoneNumberHTML}
                                    <b>Email: </b>
                                    <a href="mailto:${this.email}" style="color: rgb(5, 99, 193); text-decoration: none;">${this.email}</a>
                                    <br>
                                    <a href="https://www.amity.edu/" target="_blank" style="color: rgb(178, 14, 18); ${smallText}; text-decoration: none;">
                                        <b>www.amity.com</b>
                                    </a>
                                </span>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>`;

    this.body = this.sign;
}



}