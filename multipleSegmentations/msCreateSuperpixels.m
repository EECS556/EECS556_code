function imsegs = msCreateSuperpixels(im, imname)

prefix = num2str(floor(rand(1)*1E6));
fn1 = ['./tmpim' prefix '.ppm'];
outfn = ['./tmpimsp' prefix '.ppm'];

imwrite(im, fn1);
segcmd = 'segment/segment 0.1 100 5';
syscall = [segcmd ' ' fn1 ' ' outfn];

system(syscall);
imsegs = processSuperpixelImage(outfn);
if exist('imname', 'var')
    imsegs.imname = imname;
end

delete(fn1);
delete(outfn);