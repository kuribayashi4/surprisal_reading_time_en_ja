import glob
import os
import json
import argparse
from collections import defaultdict

parser = argparse.ArgumentParser()
parser.add_argument("--dir", required=True)
args = parser.parse_args()


def parse_path(path):
    info = path.split(os.sep)
    if info[-3] == 'ngram':
        return {'arch': 'ngram',
                'data_size': '-',
                'n_updates': '-',
                'seed': '-'} 
    else:
        return {'arch': info[-4], 
                'data_size': info[-3].split('-')[0], 
                'n_updates': info[-2].split('_')[0], 
                'seed': info[-3].split('-')[-1]}

def main():
    dir2scores = defaultdict(dict)
    files = glob.glob(f'{args.dir}/**/logLik.txt', recursive=True)
    for file in files:
        dir = os.path.dirname(file)
        info = parse_path(file)
        dir2scores[dir].update(info)

        with open(file) as f:
            for line in f:
                metric, value = line.split(':')
                dir2scores[dir].update({metric: value.strip()})

        ppl_file = os.path.join(dir, 'eval.txt')
        scores = json.load(open(ppl_file))
        for k, v in scores.items():
            dir2scores[dir][k] = str(v)

        effect_file = os.path.join(dir, 'feature_effect.txt')
        if os.path.exists(effect_file):
            with open(effect_file) as f:
                for line in f:
                    key, delta_logLik = line.split()
                    dir2scores[dir]['delta_logLik_'+key] = delta_logLik.strip()

    stats_keys = [','.join(sorted(v.keys())) for v in dir2scores.values()]
    assert len(set(stats_keys)) == 1
    print(stats_keys[0])
    for dir, scores in sorted(dir2scores.items(), key=lambda x: x[0]):
        print(','.join(s[1] for s in sorted(scores.items(), 
                                            key=lambda x: x[0])))

if __name__ == "__main__":
    main()
