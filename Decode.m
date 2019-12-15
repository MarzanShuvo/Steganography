function textString = Decode(Reconstruct,key)

LS = liftwave('haar','Int2Int');
[CAA,CHA,CVA,CDA] = lwt2(double(Reconstruct),LS);

output_after = CAA;
input_after = output_after;
height = size(output_after, 1); 
width = size(output_after, 2);
chars = key;
message_length = chars * 8;
count = 1;
for i = 1 : height
    for j = 1 : width 
        if (count <= message_length)
            extracted_bits(count, 1) = mod(double(input_after(i, j)), 2);
            count = count + 1;
        end
    end
end
binValues = [ 128 64 32 16 8 4 2 1 ];
binMatrix = reshape(extracted_bits, 8,(message_length/8));
textString = char(binValues*binMatrix);