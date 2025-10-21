const sharp = require('sharp');
const path = require('path');

async function convertSVGtoPNG() {
    try {
        // Convert app icon
        const appIconInput = path.join(__dirname, 'app_icon.svg');
        const appIconOutput = path.join(__dirname, 'app_icon_512.png');

        await sharp(appIconInput)
            .resize(512, 512)
            .png()
            .toFile(appIconOutput);

        console.log('✓ app_icon_512.png created successfully!');

        // Convert feature graphic
        const featureInput = path.join(__dirname, 'feature_graphic.svg');
        const featureOutput = path.join(__dirname, 'feature_graphic_1024x500.png');

        await sharp(featureInput)
            .resize(1024, 500)
            .png()
            .toFile(featureOutput);

        console.log('✓ feature_graphic_1024x500.png created successfully!');
        console.log('\nBoth PNG files have been generated!');
    } catch (error) {
        console.error('Error converting SVG to PNG:', error.message);
        process.exit(1);
    }
}

convertSVGtoPNG();
