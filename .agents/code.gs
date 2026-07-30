// ==========================================
// CONFIGURATION
// ==========================================
// Replace this with the ID of the Google Drive folder where you want to save uploads
// You can find the Folder ID in the URL of the Google Drive folder (e.g., https://drive.google.com/drive/folders/YOUR_DRIVE_FOLDER_ID_HERE)
const UPLOAD_FOLDER_ID = 'YOUR_DRIVE_FOLDER_ID_HERE';

/**
 * Required GAS function to serve the HTML page.
 * This runs when you visit the web app URL.
 */
function doGet() {
  return HtmlService.createHtmlOutputFromFile('index')
      .setTitle('My Portfolio')
      .setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL) // Allows embedding if needed
      .addMetaTag('viewport', 'width=device-width, initial-scale=1'); // Ensures mobile responsiveness
}

/**
 * Receives base64 encoded file data from the frontend and saves it to Google Drive.
 * 
 * @param {Object} fileData - The file object containing name, mimeType, and data (base64 string).
 * @return {String} The URL of the uploaded file on Google Drive.
 */
function uploadFileToDrive(fileData) {
  try {
    // 1. Get the designated folder where files will be saved
    const folder = DriveApp.getFolderById(UPLOAD_FOLDER_ID);
    
    // 2. Decode the base64 data
    // The data comes in format like "data:image/png;base64,iVBORw0..."
    // We split by comma to remove the prefix and get just the base64 string
    const data = fileData.data.split(',')[1]; 
    const blob = Utilities.newBlob(Utilities.base64Decode(data), fileData.mimeType, fileData.name);
    
    // 3. Create the file in the designated Google Drive folder
    const file = folder.createFile(blob);
    
    // 4. Return the file's URL so the frontend knows it was successful
    return file.getUrl();
  } catch (error) {
    // Log the error in Apps Script dashboard if something goes wrong
    Logger.log('Upload error: ' + error.toString());
    throw new Error('Upload failed: ' + error.toString());
  }
}
