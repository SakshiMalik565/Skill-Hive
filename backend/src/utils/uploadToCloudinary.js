const cloudinary = require('../config/cloudinary');

const uploadToCloudinary = (fileBuffer, options = {}) => {
  return new Promise((resolve) => {
    try {
      const stream = cloudinary.uploader.upload_stream(options, (error, result) => {
        if (error) {
          console.warn('Cloudinary upload failed (callback error):', error.message || error);
          const mimeType = options.resource_type === 'video' ? 'video/mp4' : 'image/jpeg';
          const base64Data = fileBuffer.toString('base64');
          resolve({
            secure_url: `data:${mimeType};base64,${base64Data}`,
          });
        } else {
          resolve(result);
        }
      });

      stream.end(fileBuffer);
    } catch (err) {
      console.warn('Cloudinary upload failed (sync error):', err.message || err);
      const mimeType = options.resource_type === 'video' ? 'video/mp4' : 'image/jpeg';
      const base64Data = fileBuffer.toString('base64');
      resolve({
        secure_url: `data:${mimeType};base64,${base64Data}`,
      });
    }
  });
};

module.exports = uploadToCloudinary;

