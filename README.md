arxiv: https://arxiv.org/abs/2106.01229
```
@inproceedings{kuribayashi-etal-2021,
    title = "Lower Perplexity is Not Always Human-Like",
    author = "Kuribayashi, Tatsuki  and
      Oseki, Yohei  and
      Ito, Takumi  and
      Ryo, Yoshida and
      Masayuki, Asahara and
      Inui, Kentaro",
    booktitle = "Proceedings of the Joint Conference of the 59th Annual Meeting of the Association for Computational Linguistics and the 11th International Joint Conference on Natural Language Processing",
    month = aug,
    year = "2021",
    address = "Online",
    publisher = "Association for Computational Linguistics",
}
```

## Requirement
Python version >= 3.6
```
pip install -r requirements.txt
python -m unidic download
```

### Downlod the data
https://github.com/kuribayashi4/surprisal_reading_time_en_ja/releases/tag/v0.1  
One can download the data for gaze duration modeling. 
Inappropriate data points (see Section 3.2) are alreday excluded.  
Note that the original texts are removed due to copyright issues. If you need the original text in BCCWJ-EyeTrack, please coutact https://github.com/masayu-a/BCCWJ-EyeTrack.  

### Gaze duration modeling (you can skip)
Run `modeling.ipynb` with the R kernel.  

### Aggregate the resluts (you can skip)
`python aggregate.py --dir bccwj_surprisals`  
`python aggregate.py --dir dundee_surprisals`  

### Visualize the results
Run `visualize.ipynb` with the Python kernel.  
    
  
   
## Additional examples
### Compute the surprisals from the pre-trained language models (LMs) used in our experiments
#### Download the models
Some LMs we used in the experiments are uploaded in https://github.com/kuribayashi4/surprisal_reading_time_en_ja/releases/tag/v0.2.
- Japanese LSTM LM with the best psychometric predictive power (10K updates, md dataset)
- Japanese Transformer-sm LM weith the best PPL (100K updates, lg dataset)  
- English Transformer-sm LM with nearly the best PPL and pschometric predictive power (100K updates, lg dataset)  
  
#### Toy ecxamples
Run `surprisal.ipynb` with the Python kernel.

### Train the LMs used in our experiments from scratch
#### Download the training data  
Japanese: https://github.com/kuribayashi4/surprisal_reading_time_en_ja/releases/tag/v0.3  
English: WikiText-103 character-level https://blog.einstein.ai/the-wikitext-long-term-dependency-language-modeling-dataset/  
  
⚠ After downloading, split the text into subwords with the Japanese tokenizer and sentencepiece (see `surprisal.ipynb`).   
If you replecate our experiments, please create the subsets (1/10 and 1/100) of the corpora.  
Then, create the binary data with the fairseq preprocessing (the directory should be like `scripts/{en/ja}/data-bin-{lg/md/sm}`).  

#### Train
```
cd scripts
bash train_lm.sh
```  
⚠ Highly recommended to parallelize.