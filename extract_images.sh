#!/bin/bash

IMG_DIR=$1
if [ ! -d $IMG_DIR ];then
	echo "Usage: $0 <path to otafirmware/images>"
	exit 0
fi

SYSTEM_IMG=$1/system.img
VENDOR_IMG=$1/vendor.img
PRODUCT_IMG=$1/product.img

SYSTEM_RAW=system.raw
VENDOR_RAW=vendor.raw
PRODUCT_RAW=product.raw

OUT_DIR=extracted_images_$(date +%s)
mkdir -p $OUT_DIR
OUT_DIR=$(readlink -f $OUT_DIR)

mkdir -p $OUT_DIR/tmp
OUT_TMP_DIR=$(readlink -f $OUT_DIR/tmp)

echo "[i] Converting system.img to system.raw"
simg2img $SYSTEM_IMG $OUT_TMP_DIR/$SYSTEM_RAW
echo "[i] Converting vendor.img to vendor.raw"
simg2img $VENDOR_IMG $OUT_TMP_DIR/$VENDOR_RAW
echo "[i] Converting product.img to product.raw"
simg2img $PRODUCT_IMG $OUT_TMP_DIR/$PRODUCT_RAW

cd $OUT_DIR
echo "[i] Extracting system.raw"
7z x $OUT_TMP_DIR/$SYSTEM_RAW

echo "[i] Extracting vendor.raw"
cd vendor
7z x $OUT_TMP_DIR/$VENDOR_RAW
cd ..

echo "[i] Extracting product.raw"
cd product
7z x $OUT_TMP_DIR/$PRODUCT_RAW
cd ..

cd $OUT_DIR/system
rm -rf vendor
rm -rf product

echo "[i] Creating symlinks and finishing up! OUT_DIR=$OUT_DIR"
ln -s $OUT_DIR/vendor ./vendor
ln -s $OUT_DIR/product ./product

