% Program to count the number of blue dots on a slide

% Step 1: Get a list of all image files in the "Images" folder
folderPath = 'Images'; % Replace 'Images' with the folder name containing your images
fileList = dir(fullfile(folderPath, '*.jpg')); % List jpg files
fileList = [fileList; dir(fullfile(folderPath, '*.png'))]; % Append png files to the list
fileList = [fileList; dir(fullfile(folderPath, '*.jpeg'))]; % Append jpeg files to the list

% Target colors (in LAB) for bluey and purpley shades
blueyPurpleyColorsLAB = [
    [38, 65, -85];     % #901dda
    [20, 59, -34];     % #b421b9
    [40, 85, -104];    % #9517e5
    [34, 74, -76];     % #a81dd0
    [54, 71, 9]        % #d81a6d
];

% Threshold for color difference (experiment with different values)
colorThreshold = 15;

% Step 2: Loop through each image in the folder
for i = 1:length(fileList)
    % Read the image
    imageFileName = fileList(i).name;
    imagePath = fullfile(folderPath, imageFileName);
    image = imread(imagePath);
    
    % Step 3: Convert the image to double format and scale to [0, 1]
    image = im2double(image);

    % Step 4: Convert the image to LAB color space
    labImage = rgb2lab(image);

    % Step 5: Create a binary mask for bluey/purpley dots
    mask = false(size(image, 1), size(image, 2));

    for j = 1:size(blueyPurpleyColorsLAB, 1)
        % Calculate color difference for each target color in LAB space
        colorDifference = sqrt(sum((labImage - reshape(blueyPurpleyColorsLAB(j, :), [1, 1, 3])).^2, 3));
        
        % Create a mask to include pixels close to the current target color
        mask = mask | (colorDifference < colorThreshold);
    end

    % Display the original image and the binary mask for bluey/purpley dots side by side
    figure;
    subplot(1, 2, 1);
    imshow(image);
    title([imageFileName, ' (Original Image)']);
    subplot(1, 2, 2);
    imshow(mask);
    title([imageFileName, ' (Dot Mask)']);
    
    % Step 6: Blob analysis (Optional: Uncomment if you want to count the dots)
    blobAnalysis = regionprops(mask, 'Area', 'Centroid');
    numDots = length(blobAnalysis);
    disp(['File: ', imageFileName, ' | Number of Microplatics ', num2str(numDots)]);
end
