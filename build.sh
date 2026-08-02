#!/bin/bash

set -e

# SimpleInsta - Script de build simplifie
# Utilisation: ./build.sh sideload

if [ ! -d "$THEOS" ]; then
    echo "Erreur: Theos non trouve."
    echo "Assure-toi que THEOS est defini dans ton environnement."
    echo "Exemple: export THEOS=~/theos"
    exit 1
fi

if [ "$1" == "sideload" ]; then
    echo "Building SimpleInsta pour sideloading..."
    
    make clean
    rm -rf .theos
    
    IPA_FILE="./packages/com.burbn.instagram.ipa"
    if [ ! -f "$IPA_FILE" ]; then
        echo "Erreur: com.burbn.instagram.ipa introuvable."
        echo "Place l IPA decryptee dans packages/"
        exit 1
    fi
    
    if ! command -v cyan &> /dev/null; then
        echo "Warning: cyan non trouve. Installation..."
        pip install pyzule-rw
    fi
    
    if ! command -v ipapatch &> /dev/null; then
        echo "Warning: ipapatch non trouve."
        echo "Telecharge ipapatch depuis https://github.com/asdfzxcvbn/ipapatch/releases"
        exit 1
    fi
    
    echo "Compilation du tweak..."
    make SIDELOAD=1
    
    echo "Integration dans l IPA..."
    rm -f packages/SimpleInsta-sideloaded.ipa
    cyan -i "$IPA_FILE" -o packages/SimpleInsta-sideloaded.ipa -f .theos/obj/debug/SimpleInsta.dylib -c 9 -m 15.0 -du
    
    echo "Patch de l IPA..."
    ipapatch --input packages/SimpleInsta-sideloaded.ipa --inplace --noconfirm
    
    echo ""
    echo "Termine !"
    echo "L IPA modifiee est disponible ici: $(pwd)/packages/SimpleInsta-sideloaded.ipa"
    echo "Installe-la avec AltStore ou Sideloadly."
    
elif [ "$1" == "clean" ]; then
    make clean
    rm -rf .theos packages/SimpleInsta-sideloaded.ipa
    echo "Nettoyage termine."
    
else
    echo "Utilisation: ./build.sh <sideload|clean>"
    echo ""
    echo "  sideload  - Compile et genere l IPA pour sideloading"
    echo "  clean     - Nettoie les fichiers temporaires"
    exit 1
fi
