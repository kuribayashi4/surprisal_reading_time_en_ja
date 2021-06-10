for lang in "ja" "en"
do
    for data_size in "lg" "md" "sm"
    do
        for seed in "1" "39" "46"
        do
            ./lstm_template.sh -d ${data_size} -r ${seed} -l ${lang}
            ./transformer_sm._templatesh -d ${data_size} -r ${seed} -l ${lang}
            ./transformer_lg_template.sh -d ${data_size} -r ${seed} -l ${lang}
        done
    done
done

