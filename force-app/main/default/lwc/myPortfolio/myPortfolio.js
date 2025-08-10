import { LightningElement } from 'lwc';
import PortfolioAssets from '@salesforce/resourceUrl/PortfolioAssets'
export default class MyPortfolio extends LightningElement {
 
 linkedinUrl = 'www.linkedin.com/in/venkatesh148'
 githubUrl 
 blogUrl
 mediumUrl
 trailhead1Url
 twitterUrl


 profile = PortfolioAssets +'/PortfolioAssets/userPic.jpeg'
 linkedin  = PortfolioAssets +'/PortfolioAssets/Social/linkedin.svg'
 github =`${PortfolioAssets}/PortfolioAssets/Social/github.svg`
 blog =`${PortfolioAssets}/PortfolioAssets/Social/blog.svg`
 medium =`${PortfolioAssets}/PortfolioAssets/Social/medium.svg`
 trailhead1 =`${PortfolioAssets}/PortfolioAssets/Social/trailhead1.svg`
 twitter =`${PortfolioAssets}/PortfolioAssets/Social/twitter.svg`
 



}