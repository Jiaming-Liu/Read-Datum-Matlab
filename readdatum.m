function [ datum ] = readdatum( in )
%READDATUM Read a Caffe's datum.
%	Datum is a data structure which contains an image together with its 
%   meta-data and label. 
%   The sturcture is defined by caffe/src/caffe/proto/caffe.proto, based on
%   Google's Protocol buffers.
%   ------
%   input:  in      Raw data array (uint8)
%   output: datum	The datum structure
%   ------
%   View the following pages for the details:
%   https://developers.google.com/protocol-buffers/docs/encoding
%   https://github.com/BVLC/caffe/blob/master/src/caffe/proto/caffe.proto
    datum=[];
    ptr=1;
    ptr_float_data=0;
    in = uint8(in);
    
    while ptr<=numel(in)
        
		% read key
		key=in(ptr);
        ptr = ptr+1;
        
		% determine wire type, output a value
        switch bitand(key,7)
		
			%int32/bool
            case 0
				%read num
				[value,ptr] = read128varint(in,ptr);
				
			%bytes
			case 2
				%read length
				[length,ptr] = read128varint(in,ptr);
                %read bytes[length]
				value=in(ptr:(ptr+length-1));
                
				ptr=ptr+length;
				
			%float
% Float and fixed32 have wire type 5, which tells it to expect 32 bits. In 
% both cases the values are stored in little-endian byte order.
			case 5
				% TODO
                % read bytes[4]
				warning('Type float has not been tested yet @ %d !',ptr)
				value=uint32(in(ptr:(ptr+3)));
                ptr=ptr+4;
				value = typecast( ...
                            bitor(  ...
                                bitor( ...
                                    value(1) , ...
                                    bitshift(value(2),8) ...
                                ), ...
                                bitor( ...
                                    bitshift(value(3),16) , ...
                                    bitshift(value(4),24) ...
                                )   ...
                            ) , ...
                            'single');
                
            otherwise
				error('Unknown type @ %d !',ptr)
        end
		
        % determine field
        switch bitshift(key,-3)
			case 1
				datum.channels=value;
                
			case 2
				datum.height=value;
                
			case 3
				datum.width=value;
                
			case 4
				datum.data=value;
                
			case 5
				datum.label=value;
                
            %repeated float_data
			case 6
                warning('Field float_data has not been tested yet @ %d !',ptr)
                if ptr_float_data==0
                    datum.float_data=zeros(1,length,'single');
                end
                ptr_float_data=ptr_float_data+1;
				datum.float_data(ptr_float_data)=value;
                
			case 7
				datum.encode=value;
                
			otherwise
				error('Unknown field!')
        end
    end				
end
    
function [ value,ptr ] = read128varint( in,ptr )
%READ128VARINT Read the next base 128 varint.
%   input:  in      Raw data array (uint8)
%           ptr     Previous pointer to the array in
%   output: value   Obtained int (uint32)
%           ptr     Pointer to the array in after reading
%   -------------
%   View the following page for the detail of encoding:
%   https://developers.google.com/protocol-buffers/docs/encoding

    BASE = 128;
    BASEMASK = 127;
    BASE_POWER=7;
    
    shift = 0;
    value = uint32(0);
    
    while(ptr<=numel(in))
        % read the next byte
        ii=uint32(in(ptr));
        ptr=ptr+1;
        
        % if the most significant digit(msd)=0, return the number
        if ii<BASE
            value=bitor(bitshift(ii,shift),value);
            return
        
        % if msd=1, continue reading
        else
            value=bitor(bitshift(bitand(ii,BASEMASK),shift),value);
            shift=shift+BASE_POWER;
            
        end
    end
    
    % This function should be ended by 'return'
    error('Unexpected end of array!')
    
end