function [ datum ] = demo( caffe_location )
%DEMO The demo of function readdatum
%   In this demo, we apply the library matlab-lmdb 
%   (https://github.com/kyamagu/matlab-lmdb)
%   to read the MNIST train set, and show the first picture in it.
%   -------------
%   Example
%   datum=demo('/path/to/caffe/')

% locate the database
database = lmdb.DB([caffe_location,'examples/mnist/mnist_train_lmdb/']);
% read the first datum
datum = readdatum(database.get('00000000'))
% show the image
figure
imshow(reshape(datum.data,[datum.width,datum.height])')

end

