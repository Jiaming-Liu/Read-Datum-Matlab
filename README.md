# Read-Datum-Matlab
This library enables MATLAB to read a Caffe's datum. To read it from a LMDB, you might also need matlab-lmdb:
https://github.com/kyamagu/matlab-lmdb

Datum is a data structure which contains an image together with its meta-data and label. The sturcture is defined by caffe/src/caffe/proto/caffe.proto. See https://github.com/BVLC/caffe/blob/master/src/caffe/proto/caffe.proto for the structure.
This library partly realizes the decoding of Google's Protocol buffers. View the following pages for details:
https://developers.google.com/protocol-buffers/docs/encoding

Warning: The reading of the field float_data HAS NOT BEEN TESTED yet. If there is any mistake, feel free to revise it.
