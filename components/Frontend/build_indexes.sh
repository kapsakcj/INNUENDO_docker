#!/bin/bash

# RUN on INNUENDO_REST_API folder

innuendo_dir="/Frontend/INNUENDO_REST_API"

# INNUENDO DIR
echo "INNUENDO dir: ${innuendo_dir}"

outdir="/INNUENDO/inputs"

fast_mlst_path="/Frontend/fast-mlst"

allegro_client="/Frontend/INNUENDO_REST_API/agraph-6.2.1-client-python"
export PYTHONPATH="${allegro_client}/src"

# Import version
echo "Import version: ${1}"

# Prepare Yersinia enterocolitica data
echo "---> Checking Yersinia enterocolitica data  ..."


# Create folders on defined outdir
mkdir -p ${outdir}/${1}/legacy_profiles
mkdir -p ${outdir}/${1}/indexes
mkdir -p ${outdir}/${1}/classifications
mkdir -p ${outdir}/${1}/legacy_metadata
mkdir -p ${outdir}/${1}/core_lists

if [ ! -f "${outdir}/${1}/legacy_profiles/profiles_Yersinia.tsv" ]; then

    echo "---> Downloading legacy dataset  ..."
    cd ${outdir}/${1}/legacy_profiles
    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/profiles_Yersinia.tsv
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Yenterocolitica_wgMLST_alleleProfiles.tsv
    mv Yenterocolitica_wgMLST_alleleProfiles.tsv profiles_Yersinia.tsv

    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/Yersinia_enterocolitica_metadata.txt
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Yenterocolitica_metadata.txt
    mv Yenterocolitica_metadata.txt Yersinia_enterocolitica_metadata.txt
    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/cgMLST_list_Yersinia.txt
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Yenterocolitica_cgMLST_2406_listGenes.txt
    mv Yenterocolitica_cgMLST_2406_listGenes.txt cgMLST_list_Yersinia.txt
    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/goeBURST_cgMLST_9_133_1189_yersinia.txt.1
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Yentero_correct_classification.txt
    mv Yentero_correct_classification.txt goeBURST_cgMLST_9_133_1189_yersinia.txt.1
    mv Yersinia_enterocolitica_metadata.txt ../legacy_metadata/
    mv goeBURST_cgMLST_9_133_1189_yersinia.txt.1 ../classifications/goeBURST_cgMLST_9_133_1189_yersinia.txt

    cd ${innuendo_dir}

    echo "---> Parsing mlst profiles file  ..."
    python extract_core_from_wg.py -i ${outdir}/${1}/legacy_profiles/profiles_Yersinia.tsv -g ${outdir}/${1}/legacy_profiles/cgMLST_list_Yersinia.txt -o ${outdir}/${1}/legacy_profiles/results_alleles_yersinia_wg --inverse --onlyreplace

    echo "---> Extracting mlst profiles ..."
    python extract_core_from_wg.py -i ${outdir}/${1}/legacy_profiles/profiles_Yersinia.tsv -g ${outdir}/${1}/legacy_profiles/cgMLST_list_Yersinia.txt -o ${outdir}/${1}/legacy_profiles/results_alleles_yersinia_core --inverse

    echo "---> Copying profiles headers files ..."
    cp ${outdir}/${1}/legacy_profiles/results_alleles_yersinia_core_headers.txt ${outdir}/${1}/core_lists/yersinia_headers_core.txt
    cp ${outdir}/${1}/legacy_profiles/results_alleles_yersinia_wg_headers.txt ${outdir}/${1}/core_lists/yersinia_headers_wg.txt

    echo "---> Copying initial profile files for index build ..."
    rm ${outdir}/${1}/indexes/yersinia_wg_profiles.tab
    rm ${outdir}/${1}/indexes/yersinia_core_profiles.tab
    cp ${outdir}/${1}/legacy_profiles/results_alleles_yersinia_core.tsv ${outdir}/${1}/indexes/yersinia_core_profiles.tab
    cp ${outdir}/${1}/legacy_profiles/results_alleles_yersinia_wg.tsv ${outdir}/${1}/indexes/yersinia_wg_profiles.tab

    echo "---> Building profile file index ..."
    rm ${outdir}/${1}/indexes/yersinia_core.idx
    rm ${outdir}/${1}/indexes/yersinia_wg.idx
    rm ${outdir}/${1}/indexes/yersinia_core.ids
    rm ${outdir}/${1}/indexes/yersinia_wg.ids
    cat ${outdir}/${1}/indexes/yersinia_core_profiles.tab | ${fast_mlst_path}/src/main -i ${outdir}/${1}/indexes/yersinia_core -b
    cat ${outdir}/${1}/indexes/yersinia_wg_profiles.tab | ${fast_mlst_path}/src/main -i ${outdir}/${1}/indexes/yersinia_wg -b

fi

# Prepare Salmonella data
echo "---> Checking Salmonella enterica data  ..."

if [ ! -f "${outdir}/${1}/legacy_profiles/profiles_Salmonella.tsv" ]; then

    echo "---> Downloading legacy dataset  ..."
    cd ${outdir}/${1}/legacy_profiles
    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/profiles_Salmonella.tsv
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Senterica_wgMLST_alleleProfiles.tsv
    mv Senterica_wgMLST_alleleProfiles.tsv profiles_Salmonella.tsv
    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/Salmonella_enterica_metadata.txt
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Senterica_metadata.txt
    mv Senterica_metadata.txt Salmonella_enterica_metadata.txt
    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/cgMLST_list_Salmonella.txt
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Senterica_cgMLST_3255_listGenes.txt
    mv Senterica_cgMLST_3255_listGenes.txt cgMLST_list_Salmonella.txt
    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/goeBURST_cgMLST_7_338_997_salmonella.txt.1
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Salmonella_goeBURST_cgMLST_cleaned.-.goeBURST_cgMLST_cleaned.tsv
    mv Salmonella_goeBURST_cgMLST_cleaned.-.goeBURST_cgMLST_cleaned.tsv goeBURST_cgMLST_7_338_997_salmonella.txt.1
    mv Salmonella_enterica_metadata.txt ../legacy_metadata/
    mv goeBURST_cgMLST_7_338_997_salmonella.txt.1 ../classifications/goeBURST_cgMLST_7_338_997_salmonella.txt

    cd ${innuendo_dir}

    echo "---> Parsing mlst profiles file  ..."
    python extract_core_from_wg.py -i ${outdir}/${1}/legacy_profiles/profiles_Salmonella.tsv -g ${outdir}/${1}/legacy_profiles/cgMLST_list_Salmonella.txt -o ${outdir}/${1}/legacy_profiles/results_alleles_salmonella_wg --inverse --onlyreplace

    echo "---> Extracting mlst profiles ..."
    python extract_core_from_wg.py -i ${outdir}/${1}/legacy_profiles/profiles_Salmonella.tsv -g ${outdir}/${1}/legacy_profiles/cgMLST_list_Salmonella.txt -o ${outdir}/${1}/legacy_profiles/results_alleles_salmonella_core --inverse

    echo "---> Copying profiles headers files ..."
    cp ${outdir}/${1}/legacy_profiles/results_alleles_salmonella_core_headers.txt ${outdir}/${1}/core_lists/salmonella_headers_core.txt
    cp ${outdir}/${1}/legacy_profiles/results_alleles_salmonella_wg_headers.txt ${outdir}/${1}/core_lists/salmonella_headers_wg.txt

    echo "---> Copying initial profile files for index build ..."
    rm ${outdir}/${1}/indexes/salmonella_wg_profiles.tab
    rm ${outdir}/${1}/indexes/salmonella_core_profiles.tab
    cp ${outdir}/${1}/legacy_profiles/results_alleles_salmonella_core.tsv ${outdir}/${1}/indexes/salmonella_core_profiles.tab
    cp ${outdir}/${1}/legacy_profiles/results_alleles_salmonella_wg.tsv ${outdir}/${1}/indexes/salmonella_wg_profiles.tab

    echo "---> Building profile file index ..."
    rm ${outdir}/${1}/indexes/salmonella_core.idx
    rm ${outdir}/${1}/indexes/salmonella_wg.idx
    rm ${outdir}/${1}/indexes/salmonella_core.ids
    rm ${outdir}/${1}/indexes/salmonella_wg.ids
    cat ${outdir}/${1}/indexes/salmonella_core_profiles.tab | ${fast_mlst_path}/src/main -i ${outdir}/${1}/indexes/salmonella_core -b
    cat ${outdir}/${1}/indexes/salmonella_wg_profiles.tab | ${fast_mlst_path}/src/main -i ${outdir}/${1}/indexes/salmonella_wg -b

fi

# Prepare Escherichia coli data
echo "---> Checking Escherichia coli data  ..."

if [ ! -f "${outdir}/${1}/legacy_profiles/profiles_Ecoli.tsv" ]; then

    echo "---> Downloading legacy dataset  ..."
    cd ${outdir}/${1}/legacy_profiles
    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/profiles_Ecoli.tsv
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Ecoli_wgMLST_alleleProfiles.tsv
    mv Ecoli_wgMLST_alleleProfiles.tsv profiles_Ecoli.tsv
    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/Escherichia_coli_metadata.txt
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Ecoli_metadata.txt
    mv Ecoli_metadata.txt Escherichia_coli_metadata.txt
    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/cgMLST_list_Ecoli.txt
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Ecoli_cgMLST_2360_listGenes.txt
    mv Ecoli_cgMLST_2360_listGenes.txt cgMLST_list_Ecoli.txt
    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/goeBURST_FULL_8_112_793_ecoli.txt
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Ecoli_goeBURST_FULL_pub.-.goeBURST_FULL.tsv
    mv Ecoli_goeBURST_FULL_pub.-.goeBURST_FULL.tsv goeBURST_FULL_8_112_793_ecoli.txt
    mv Escherichia_coli_metadata.txt ../legacy_metadata/
    mv goeBURST_FULL_8_112_793_ecoli.txt ../classifications/goeBURST_FULL_8_112_793_ecoli.txt

    cd ${innuendo_dir}

    echo "---> Parsing mlst profiles file  ..."
    python extract_core_from_wg.py -i ${outdir}/${1}/legacy_profiles/profiles_Ecoli.tsv -g ${outdir}/${1}/legacy_profiles/cgMLST_list_Ecoli.txt -o ${outdir}/${1}/legacy_profiles/results_alleles_ecoli_wg --inverse --onlyreplace

    echo "---> Extracting mlst profiles ..."
    python extract_core_from_wg.py -i ${outdir}/${1}/legacy_profiles/profiles_Ecoli.tsv -g ${outdir}/${1}/legacy_profiles/cgMLST_list_Ecoli.txt -o ${outdir}/${1}/legacy_profiles/results_alleles_ecoli_core --inverse

    echo "---> Copying profiles headers files ..."
    cp ${outdir}/${1}/legacy_profiles/results_alleles_ecoli_core_headers.txt ${outdir}/${1}/core_lists/ecoli_headers_core.txt
    cp ${outdir}/${1}/legacy_profiles/results_alleles_ecoli_wg_headers.txt ${outdir}/${1}/core_lists/ecoli_headers_wg.txt

    echo "---> Copying initial profile files for index build ..."
    rm ${outdir}/${1}/indexes/ecoli_wg_profiles.tab
    rm ${outdir}/${1}/indexes/ecoli_core_profiles.tab
    cp ${outdir}/${1}/legacy_profiles/results_alleles_ecoli_core.tsv ${outdir}/${1}/indexes/ecoli_core_profiles.tab
    cp ${outdir}/${1}/legacy_profiles/results_alleles_ecoli_wg.tsv ${outdir}/${1}/indexes/ecoli_wg_profiles.tab

    echo "---> Building profile file index ..."
    rm ${outdir}/${1}/indexes/ecoli_core.idx
    rm ${outdir}/${1}/indexes/ecoli_wg.idx
    rm ${outdir}/${1}/indexes/ecoli_core.ids
    rm ${outdir}/${1}/indexes/ecoli_wg.ids
    cat ${outdir}/${1}/indexes/ecoli_core_profiles.tab | ${fast_mlst_path}/src/main -i ${outdir}/${1}/indexes/ecoli_core -b
    cat ${outdir}/${1}/indexes/ecoli_wg_profiles.tab | ${fast_mlst_path}/src/main -i ${outdir}/${1}/indexes/ecoli_wg -b

fi

# Prepare Campylobacter jejuni/coli data
echo "---> Checking Campylobacter jejuni data  ..."

if [ ! -f "${outdir}/${1}/legacy_profiles/profiles_Cjejuni.tsv" ]; then

    echo "---> Downloading legacy dataset  ..."
    cd ${outdir}/${1}/legacy_profiles
    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/profiles_CcoliCjejuni.tsv
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Cjejuni_wgMLST_alleleProfiles.tsv
    mv Cjejuni_wgMLST_alleleProfiles.tsv profiles_Cjejuni.tsv
    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/Campylobacter_coli_jejuni_metadata.txt
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Cjejuni_metadata.txt
    mv Cjejuni_metadata.txt Campylobacter_jejuni_metadata.txt
    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/cgMLST_list_ccolicjejuni.tsv
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Cjejuni_cgMLST_678_listGenes.txt
    mv Cjejuni_cgMLST_678_listGenes.txt cgMLST_list_cjejuni.tsv
    #wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/v1.0/goeBURST_cgMLST_4_59_292_campy.txt
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Campylobacter_goeBURST_cgMLST_correct.tsv
    mv Campylobacter_goeBURST_cgMLST_correct.tsv goeBURST_cgMLST_4_59_292_campy.txt
    mv Campylobacter_jejuni_metadata.txt ../legacy_metadata/
    mv goeBURST_cgMLST_4_59_292_campy.txt ../classifications/goeBURST_cgMLST_4_59_292_campy.txt

    cd ${innuendo_dir}

    echo "---> Parsing mlst profiles file  ..."
    python extract_core_from_wg.py -i ${outdir}/${1}/legacy_profiles/profiles_Cjejuni.tsv -g ${outdir}/${1}/legacy_profiles/cgMLST_list_cjejuni.tsv -o ${outdir}/${1}/legacy_profiles/results_alleles_campy_wg --inverse --onlyreplace

    echo "---> Extracting mlst profiles ..."
    python extract_core_from_wg.py -i ${outdir}/${1}/legacy_profiles/profiles_Cjejuni.tsv -g ${outdir}/${1}/legacy_profiles/cgMLST_list_cjejuni.tsv -o ${outdir}/${1}/legacy_profiles/results_alleles_campy_core --inverse

    echo "---> Copying profiles headers files ..."
    cp ${outdir}/${1}/legacy_profiles/results_alleles_campy_core_headers.txt ${outdir}/${1}/core_lists/campy_headers_core.txt
    cp ${outdir}/${1}/legacy_profiles/results_alleles_campy_wg_headers.txt ${outdir}/${1}/core_lists/campy_headers_wg.txt

    echo "---> Copying initial profile files for index build ..."
    rm ${outdir}/${1}/indexes/campy_wg_profiles.tab
    rm ${outdir}/${1}/indexes/campy_core_profiles.tab
    cp ${outdir}/${1}/legacy_profiles/results_alleles_campy_core.tsv ${outdir}/${1}/indexes/campy_core_profiles.tab
    cp ${outdir}/${1}/legacy_profiles/results_alleles_campy_wg.tsv ${outdir}/${1}/indexes/campy_wg_profiles.tab

    echo "---> Building profile file index ..."
    rm ${outdir}/${1}/indexes/campy_core.idx
    rm ${outdir}/${1}/indexes/campy_wg.idx
    rm ${outdir}/${1}/indexes/campy_core.ids
    rm ${outdir}/${1}/indexes/campy_wg.ids
    cat ${outdir}/${1}/indexes/campy_core_profiles.tab | ${fast_mlst_path}/src/main -i ${outdir}/${1}/indexes/campy_core -b
    cat ${outdir}/${1}/indexes/campy_wg_profiles.tab | ${fast_mlst_path}/src/main -i ${outdir}/${1}/indexes/campy_wg -b

fi

 echo "---> Checking Vibrio cholerae data  ..."

# Check if the V. cholerae file exists in the out directory, If not, it
# will download all the required files and build the Salmonella database.
if [ ! -f "${outdir}/${1}/legacy_profiles/profiles_VibrioCholerae.tsv" ]; then

     echo "---> Downloading legacy dataset  ..."
     cd ${outdir}/${1}/legacy_profiles
     # Get wgMLST profiles for V. cholerae
     wget https://raw.githubusercontent.com/kapsakcj/INNUENDO_schemas/master/Vcholerae_cgMLST_alleleProfiles.txt
     mv Vcholerae_cgMLST_alleleProfiles.txt profiles_VibrioCholerae.tsv
     # Get V. cholerae metadata for the legacy dataset
     wget https://raw.githubusercontent.com/kapsakcj/INNUENDO_schemas/master/Vcholerae_metadata.txt
     mv Vcholerae_metadata.txt Vibrio_cholerae_metadata.txt
     # Get the list of cgMLST genes for V. cholerae in the legacy schema
     wget https://raw.githubusercontent.com/kapsakcj/INNUENDO_schemas/master/Vcholerae_cgMLST_2404_listGenes.txt
     mv Vcholerae_cgMLST_2404_listGenes.txt cgMLST_list_VibrioCholerae.txt
     # Get INNUENDO classification file
     wget https://raw.githubusercontent.com/kapsakcj/INNUENDO_schemas/master/Vcholera_correct_classification.txt
     # no need to rename our VC correct classification file
     #mv Salmonella_goeBURST_cgMLST_cleaned.-.goeBURST_cgMLST_cleaned.tsv goeBURST_cgMLST_7_338_997_salmonella.txt.1

     # move metadata
     mv Vibrio_cholerae_metadata.txt ../legacy_metadata/
     # move INNUENDO classification file
     mv Vcholera_correct_classification.txt ../classifications/

     cd ${innuendo_dir}

     echo "---> Parsing mlst profiles file  ..."
     python extract_core_from_wg.py -i ${outdir}/${1}/legacy_profiles/profiles_VibrioCholerae.tsv -g ${outdir}/${1}/legacy_profiles/cgMLST_list_VibrioCholerae.txt -o ${outdir}/${1}/legacy_profiles/results_alleles_vibrio_wg --inverse --onlyreplace

     echo "---> Extracting mlst profiles ..."
     python extract_core_from_wg.py -i ${outdir}/${1}/legacy_profiles/profiles_VibrioCholerae.tsv -g ${outdir}/${1}/legacy_profiles/cgMLST_list_VibrioCholerae.txt -o ${outdir}/${1}/legacy_profiles/results_alleles_vibrio_core --inverse

     echo "---> Copying profiles headers files ..."
     cp ${outdir}/${1}/legacy_profiles/results_alleles_vibrio_core_headers.txt ${outdir}/${1}/core_lists/vibrio_headers_core.txt
     cp ${outdir}/${1}/legacy_profiles/results_alleles_vibrio_wg_headers.txt ${outdir}/${1}/core_lists/vibrio_headers_wg.txt

     echo "---> Copying initial profile files for index build ..."
     rm ${outdir}/${1}/indexes/vibrio_wg_profiles.tab
     rm ${outdir}/${1}/indexes/vibrio_core_profiles.tab
     cp -v ${outdir}/${1}/legacy_profiles/results_alleles_vibrio_core.tsv ${outdir}/${1}/indexes/vibrio_core_profiles.tab
     cp -v ${outdir}/${1}/legacy_profiles/results_alleles_vibrio_wg.tsv ${outdir}/${1}/indexes/vibrio_wg_profiles.tab

     echo "---> Building profile file index ..."
     rm ${outdir}/${1}/indexes/vibrio_core.idx
     rm ${outdir}/${1}/indexes/vibrio_wg.idx
     rm ${outdir}/${1}/indexes/vibrio_core.ids
     rm ${outdir}/${1}/indexes/vibrio_wg.ids
     cat ${outdir}/${1}/indexes/vibrio_core_profiles.tab | ${fast_mlst_path}/src/main -i ${outdir}/${1}/indexes/vibrio_core -b
     cat ${outdir}/${1}/indexes/vibrio_wg_profiles.tab | ${fast_mlst_path}/src/main -i ${outdir}/${1}/indexes/vibrio_wg -b


### COMMENTING OUT - THESE ARE LEFTOVER LINES FROM THE NON-DOCKER VERSION OF INNUENDO
### I DO NOT THINK THESE ARE NEEDED FOR DOCKER-COMPOSE VERSION - CJK 2020-08-27
#     echo "---> Populating Profile Database ..."
#     flask/bin/python mlst_profiles_to_db.py -i ${outdir}/${1}/legacy_profiles/profiles_VibrioCholerae.tsv -c ${outdir}/${1}/classifications/Vcholera_correct_classification.txt -m ${outdir}/${1}/legacy_metadata/Vibrio_cholerae_metadata.txt -d Vibrio -p NFP -v ${4}
fi
