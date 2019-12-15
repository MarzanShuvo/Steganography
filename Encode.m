function xRecInt = Encode(message, Channel)

len = length(message) * 8; 
ascii_value = uint8(message);
binary = dec2bin(ascii_value, 8);
bin_message = transpose(dec2bin(ascii_value, 8)); 
bin_message = bin_message(:);
N = length(bin_message);
bin_num_message= str2num(bin_message);
sX=size(Channel);
LS = liftwave('haar','Int2Int');
[CA,CH,CV,CD] = lwt2(double(Channel),LS);
input = CA;
output = input;

height = size(input, 1); 
width = size(input, 2); 

embed = 1;

for i = 1 : height 
     for j = 1 : width
         if(embed <= len)
             LSB = mod(double(input(i, j)), 2);
             template = double(xor(LSB, bin_num_message(embed)));
             output(i, j) = input(i, j)+template;
             embed = embed+1;
         end
     end
end

W = liftwave('haar','Int2Int');
xRecInt = ilwt2(output,CH,CV,CD,W);
xRecInt = uint8(xRecInt);
