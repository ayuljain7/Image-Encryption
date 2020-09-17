
.......This is applicabel in a way that refrence image size should be double that of the original image ......
    .....................................................................................................
    


tic;                            %starting the clock to trace time of running. 
clear all;


    

img=imread('add_full_path_of_the_image_file_here(example: home/Original-Lena-Color-Image.png)');   %reading image to be encripted..(use image path accoringly.)..........
[m,n s]=size(img);

.........................$...ENCRIPTION...$ ............................. 
    .................................................................
        .....................................................
        
    
    
    

.............................Pre encription................................
   .................................................................



kr=mod(randi([0 255],m,1),m);                   %generate two random vectora size equal to number of rows and number
kc=mod(randi([0 255],n,1),n);                   %of columns. They will serve as  keys for decription.


kr_flip=fliplr(kr);
kc_flip=fliplr(kc);                 %flipping the keys needed in algorithm

for c=1:3                       %loop begins for three (RGB) modules to seperately pre encript the original image 
                                % according to rubik's cube encription algorithm.
image=img(:,:,c);               


%............................Rubik's Cube Encription......................


%................................rotating rows............................
for i=1:m
    alpha(i)=sum(image(i,:));
    m_alpha(i)=mod(alpha(i),uint8(2));
    if m_alpha(i)==0
        i_enc(i,:)=circshift(image(i,:),kr(i));
    else
        i_enc(i,:)=circshift(image(i,:),n-kr(i));
    end
end


%.............................rotating columns............................
for j=1:n
    beta(j)=sum(i_enc(:,j));
    m_beta(j)=mod(beta(j),uint8(2));
    if m_beta(j)==0
        i_enc1(:,j)=circshift(i_enc(:,j),m-kc(j));
    else
        i_enc1(:,j)=circshift(i_enc(:,j),kc(j));
    end
end


%..........................mixing intensities of rows.....................
for i=1:m
    for j=1:n
    if mod(i,2)==1
        I_enc(i,j)=bitxor(i_enc1(i,j),kc(j));
    else
        I_enc(i,j)=bitxor(i_enc1(i,j),kc_flip(j));
    end
    end
end

%........................mixing intensities of columns.....................
 for j=1:n
    for i=1:m
    if mod(j,2)==1
        IMAGE(i,j)=bitxor(I_enc(i,j),kr(i));
    else
        IMAGE(i,j)=bitxor(I_enc(i,j),kr_flip(i));
    end
    end
 end

 
 ENC_IMAGE(:,:,c)=IMAGE;            %.........Pre encripted image formation module wise...........
 
end


%..................................DWT encription............................
        .........................................................


ref_image=imread('add_full_path_of_the_image_file_here(exaple:/home/rohitmm/Pictures/FROG_POND.jpg)');   %reading refrence image..(use image path accoringly.)..
[ref_m ref_n]=size(ref_image);
[ca,ch,cv,cd]=dwt2(im2double(ref_image),'db2'); %........2D Wavelet transform of refrence image
                                                %some other mother wavelet
                                                %can also used insted of
                                                %'db2'

enc_image= double(ENC_IMAGE);               %uint88 to double conversion on pre-encripted image
[enc_m enc_n enc_s ]=size(enc_image);


 c1=enc_image ./10000;              %To hide the information in Cv pixes values divided by 10000.            

 
 %...............adjustment of sizes and bounderies......................
 %...........needed beacuse some errors occured during implementation.....
 
 c1(enc_m+1,:,:)=double(0);
 c1(:,enc_n+1,:)=double(0);
 
 c2(1,:,1:3)=double(0);
 c2(:,1,1:3)=double(0);
 c2(2:enc_m+2,2:enc_n+2,1:3)=c1;
 
 ca2(1,:,1:3)=double(0);
 ca2(:,1,1:3)=double(0);
 ca2(2:enc_m+2,2:enc_n+2,1:3)=ca;
 
 ch2(1,:,1:3)=double(0);
 ch2(:,1,1:3)=double(0);
 ch2(2:enc_m+2,2:enc_n+2,1:3)=ch;
 
 cd2(1,:,1:3)=double(0);
 cd2(:,1,1:3)=double(0);
 cd2(2:enc_m+2,2:enc_n+2,1:3)=cd;
 
 %........................................................................
 
ref_image_rec=idwt2(ca2,ch2,c2,cd2,'db2');  %reconstructing refrence image with our information hidden in it





%.........................$...DECRIPTION...$...............................
    .............Keys kr and kc need to be provided........................
         .......................................................
         
     
     
     
     .................DWT Decription.....................................
         ...............................................
         
[dec_ca,dec_ch,dec_cv,dec_cd]=dwt2(ref_image_rec,'db2'); ....wavelet tansform of encripted image
dec_image1=uint8(dec_cv.*10000);                       ....retrieving our stored information 
dec_image_rgb=dec_image1(2:enc_m+1,2:enc_n+1,:);        .... adjusting sizes(remove extra added zeroes)


........................Decription of pre-encripted image.................
    .................................................................

for d=1:3                                %loop begins for three (RGB) modules to seperately decript the 
                                          %pre-encripted image.
    
   dec_image=dec_image_rgb(:,:,d);

 ..............regaining intensities of columns............................

for j=1:n
    for i=1:m
    if mod(j,2)==1
        I1(i,j)=bitxor(dec_image(i,j),kr(i));
    else
        I1(i,j)=bitxor(dec_image(i,j),kr_flip(i));
    end
    end
end

......................Regaining intensities of rows........................
 
for i=1:m
    for j=1:n
    if mod(i,2)==1
        I2(i,j)=bitxor(I1(i,j),kc(j));
    else
        I2(i,j)=bitxor(I1(i,j),kc_flip(j));
    end
    end
end

...................Reverse rotating columns...............................

for j=1:n
    beta_scr(j)=sum(I2(:,j));
    m_beta_scr(j)=mod(beta_scr(j),uint8(2));
    if m_beta_scr(j)==0
        I3(:,j)=circshift(I2(:,j),kc(j));
    else
        I3(:,j)=circshift(I2(:,j),m-kc(j));
    end
end

...........................Reverse rotating rows..........................

for i=1:m
    alpha_scr(i)=sum(I3(i,:));
    m_alpha_scr(i)=mod(alpha_scr(i),uint8(2));
    if m_alpha_scr(i)==0
        I4(i,:)=circshift(I3(i,:),n-kr(i));
    else
        I4(i,:)=circshift(I3(i,:),kr(i));
    end
end
........................................................................
    
DEC_IMAGE(:,:,d)=I4;    .....formation of final decripted image module wise

end

...............Displaying various step images .............................
subplot(231)
imshow(img);title('original image');
subplot(232)
imshow(ENC_IMAGE);title('pre-encripted image');
subplot(233)
imshow(ref_image);title('refrence image');
subplot(235)
imshow(dec_image_rgb);title('decripted pre-encripted image');
subplot(236)
imshow(DEC_IMAGE);title('decripted image');
subplot(234)
imshow(ref_image_rec);title('encripted  image');


....................$$....END...$$.......................................

toc           .....clock ends here........................................




