clc
% picture and message reading
im1 = imread('image.jpg');

message = fileread('message.txt');
lenght1 = length(message);
redChannel = im1(:,:,1); % Red channel
greenChannel = im1(:,:,2); % Green channel
blueChannel = im1(:,:,3); % Blue channel
%%
message = fileread('message.txt');%x is bit-stream
lx = (length(message));
half = ceil(lx/2);%for odd number of bit-stream length
s1 = message(1:half);
s2 = message(half + 1 : end); 
length_s1 = length(s1);
length_s2 = length(s2);
%%
message_length = int2str(lx);
signature = 'random_number_generation,';
length_signature = length(signature);
string_sig = strcat(signature,message_length);
mes_len = length(string_sig);
red = Encode(string_sig, redChannel);
%%
green_encode = Encode(s1, greenChannel);
%%
blue_encode = Encode(s2, blueChannel);
%%
rgb =  cat(3, red,green_encode, blue_encode);
%%
redChannel_after = rgb(:,:,1); % Red channel
greenChannel_after = rgb(:,:,2); % Green channel
blueChannel_after = rgb(:,:,3); % Blue channel
%%
%red channel data extruction
textString_length = Decode(redChannel_after,mes_len);
code = split(textString_length,",");
key = str2num(code{2});
%%
%green channel data extruction
textString_s1 = Decode_message(greenChannel_after,key);
%%
%red channel data extruction
textString_s2 = Decode_message(blueChannel_after,key);
%%
% join message
s = strcat(textString_s1,textString_s2);
extructed_length = sprintf('Mesaage length is: %s\n',code{2});
extructed = sprintf('Mesaage is: %s\n',s);
disp(extructed_length)
disp(extructed)

%%
% three channel reconstruction
rgb_after =  cat(3, redChannel_after,greenChannel_after, blueChannel_after);
%%
%display MSE
origImg = double(im1);
distImg = double(rgb_after);
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
subplot(2,2,2), imshow(rgb), title('Secret Image');
subplot(2,2,3), imshow(rgb_after), title('Secret Image Reconstructed');