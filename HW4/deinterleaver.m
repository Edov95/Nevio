function [deinterleaved_bits] = deinterleaver(bits)
   
deinterleaved_bits = zeros(1,length(bits));
    
rows = 41;
columns = 43;
    
  for matrix = 0:(length(bits)/(rows*columns) - 1)
    curr_matrix = matrix * rows * columns;
    for col = 0:(columns-1)
      deinterleaved_bits(curr_matrix + col * rows + 1 : curr_matrix...
          + col * rows + rows) = bits(curr_matrix + col + 1 : columns : ...
          curr_matrix + col + columns * rows);
    end
  end
end