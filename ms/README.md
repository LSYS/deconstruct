# texCheckmate
Shell and Make utilities to inspect a LaTeX manuscript. 

Most are taken from Jonathan Dingel's logbook `Makefile`: [https://github.com/jdingel/projecttemplate/blob/master/paper/reviewing/Makefile](https://github.com/jdingel/projecttemplate/blob/master/paper/reviewing/Makefile).

See this [note](https://www.lucasshen.com/notes/texCheckmate/texCheckmate) for more details.

## Assumptions
* The manuscript is `./main.tex` (if not, the scripts need to be changed).

## Use with `Make`
Comes with a `Makefile`, with quick CLI access to the utilities, some of which call scripts from [https://github.com/LSYS/texCheckmate/tree/main/inspecting](https://github.com/LSYS/texCheckmate/tree/main/inspecting). 

```console
acronyms         Find and tally acronyms
aynumeric        Change author-year to numeric citation
cleantex         Clean aux output files in LaTex compilation
dueto            Find "due to"s; Did you mean "because of", "owing to", or "from"?
duplicated_labels Check for duplicated labels
hardcodednumbers Find hardcoded numbers
help             Show this help message and exit
inspect          Do all inspections of manuscript
linkchecker      Check URLs
numericay        Change author-year to numeric citation
repeated_strings Check for repeated words
textidote        Check with textidote
unreferenced_labels Check for label referencing
wordcount        Wordcount via texcount
```

## Cloning
```bash
git clone https://github.com/LSYS/texCheckmate.git
mv texCheckmate/* .
rm -r texCheckmate
```

## Porting (w/o Git)
To download the utilities without cloning:

1. Download the zipped repo

```bash
wget -v https://github.com/LSYS/texCheckmate/archive/refs/heads/main.zip
```

2. Unzip

```bash
unzip main.zip
```

3. Remove the `README.md` & repo CI
```bash
rm texCheckmate-main/README.md
rm -r texCheckmate-main/.github
```

4. Move to ./
```bash
mv texCheckmate-main/* .
```

5. Clean up

```bash
rm -r texCheckmate-main
rm main.zip
```

All together:
```bash
wget -v https://github.com/LSYS/texCheckmate/archive/refs/heads/main.zip
unzip main.zip
rm texCheckmate-main/README.md
rm -r texCheckmate-main/.github
mv texCheckmate-main/* .
rm -r texCheckmate-main
rm main.zip
```








