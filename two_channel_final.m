clc
% picture and message reading
im1 = imread('image.jpg');

message = fileread('message.txt');
lenght1 = length(message);
redChannel = im1(:,:,1); % Red channel
greenChannel = im1(:,:,2); % Green channel
blueChannel = im1(:,:,3); % Blue channel
%%
%red channel encode
message_length = int2str(lenght1);
signature = 'random_number_generation,';
length_signature = length(signature);
string_sig = strcat(signature,message_length);
mes_len = length(string_sig);
red = Encode(string_sig, redChannel);
%%
%green channel encode
green_encode = Encode(message, greenChannel);
%%
rgbImage = cat(3, red, green_encode, blueChannel);
%%
redChannel_after = rgbImage(:,:,1); % Red channel
greenChannel_after = rgbImage(:,:,2); % Green channel
blueChannel_after = rgbImage(:,:,3); % Blue channel
%%
%red channel data extruction
textString_length = Decode(redChannel_after,mes_len);
code = split(textString_length,",");
key = str2num(code{2});
%%
%green channel data extruction
textString = Decode(greenChannel_after,key);
%%
%displaying message length and message
extructed_length = sprintf('Mesaage length is: %s\n',textString_length);
extructed = sprintf('Mesaage is: %s\n',textString);
disp(extructed_length)
disp(extructed)
%%
% three channel reconstruction
rgbimage_after =  cat(3, redChannel_after,greenChannel_after, blueChannel_after);
%%
%display MSE
origImg = double(im1);
distImg = double(rgbImage);
[D F] = size(origImg);
error = origImg - distImg;
MSE = sum(sum(error .* error)) / (D * F);
mse = sprintf('MSE is: %0.6f\n',MSE);
disp(mse)

%%
%display PSNR
for j=1 :length(MSE)
    
    if(MSE > 0)
        
        PSNR = 10*log(255*255/MSE) / log(10);
     
    else
        
        PSNR = 99;
    end
    psnr = sprintf('PSNR is: %0.6f\n',PSNR);
    disp(psnr)
end
%%
%display NK
NK = sum(sum(origImg .* distImg)) ./ sum(sum(origImg .* origImg));
NK = sprintf('NK is: %0.6f\n',NK);
disp(NK)
%%
figure;
subplot(2,2,1), imshow(im1), title('Original Image');
subplot(2,2,2), imshow(rgbImage), title('Secret Image');
subplot(2,2,3), imshow(rgbimage_after), title('Secret Image Reconstructed');