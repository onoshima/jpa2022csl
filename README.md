# jpa2022.csl

「[日本心理学会 執筆・投稿の手びき 2022年版](https://psych.or.jp/manual/)」（以下，「手びき2022」と呼びます）に対応したCSLファイル`jpa2022.csl`です。外国語文献の処理については[apa.csl](https://github.com/citation-style-language/styles/blob/master/apa.csl)の一部を変更した以外はほぼそのまま使っていて，日本語文献の処理用の箇所を書き加えました。

後述する特殊な作り方をしたCSL用jsonファイルを用いることで，引用文献をおおむね[^1]正しく表示できます。

[^1]:具体的には文中，文末での引用の際に著者の姓が一人でも異なっていれば手びき2022に合うように表示されますが，著者の名のみ違う文献があった場合には適切に処理できません。

jsonファイルの作り方が特殊なため，以下のソフトウェアと併用することを前提に作りました。
インストールされていない場合には事前にインストールしておいてください。

- [Pandoc](https://pandoc.org/)
- [Zotero](https://www.zotero.org/)
- [Better BibTeX for Zotero](https://retorque.re/zotero-better-bibtex/)
- [TeXLive](https://tug.org/texlive/)

## 使い方

`jpa2022.csl`をダウンロードします。Pandoc（あるいはRmarkdownなど）で文章を変換するときに`--citeproc --bibliography=<your_reference_file.json> --csl=jpa2022.csl `のようにオプションを与えることで手びき2022に対応した文献が出力されます（`<your_reference_file.json>`は自身の文献リストのファイルに置き換えてください）。

例えば，`sample`フォルダ内の`sample1.md`という原稿ファイルと書誌情報を含んだ`sample1.json`，`jpa2022.csl`を同じファイルに入れてMacならターミナル，Windowsならコマンドプロントで以下のコマンドを実行することで文中の引用および文献が処理された`.docx`ファイルが生成されます。

```
pandoc sample1.md -o sample1.docx --citeproc --bibliography=sample1.json --csl=jpa2022.csl
```

また，参考文献リストのみ欲しいときには`sample`フォルダ内の`sample2.md`のような原稿ファイルを用意して，以下のようなコマンドを実行します。

```
pandoc sample2.md -o sample2.docx --citeproc --bibliography=sample2.json --csl=jpa2022.csl
```

Pandocを用いて引用文献を処理する方法についてさらに知りたい方は以下のリンクが参考になります。

- [Pandocで参考文献リストを処理する扱う方法 (PandocとZoteroで参考文献：後編)](https://zenn.dev/sky_y/articles/pandoc-advent-2020-bib2)

## jpa2022.csl用のjsonファイルの作成方法

CSLは複数の言語に対応しているのですが，手びき2022のように一つの文献リストの中で日本語と外国語で出力の形式を分けるような使い方は想定されていません（参考：[CSLの公式サイトの説明](https://citationstyles.org/authors/#localization)の Localizationの3パラグラフ目の後半）。

仕方がないので`jpa2022.csl`では，改造のもとにした`apa.csl`で使われていない変数に日本語文献の表示に必要な情報を格納して，その値に基づき表示方法を分けることにしました。日本語文献の読みに割り当てた`curator`変数に何か値が入っていると，日本語文献として処理するようになっています。また，翻訳書籍名に割り当てた`dimensions`変数に何か値が入っていると翻訳書であると判断して文献を表記するようになっています。

以下がCSLの変数とそこに含める情報の対応表です（Zoteroの「その他」に入力する変数名については後に説明します）。

| CSL variable      | 書誌情報                             | Zoteroの「その他」に入力する変数名 |
| ----------------- | ------------------------------------ | ---------------------------------- |
| curator           | 日本語文献の読み                     | yomi                               |
| producer          | 監修者                               | kanshu                             |
| guest             | 監訳者（翻訳書）                     | Jkanyaku                           |
| host              | 翻訳者（翻訳書）                     | Jauthor                            |
| dimensions        | 翻訳書籍名                           | Jtitle                             |
| compiler          | 原著者性名（性はカタカナ，名は英語） | genchoKANA                         |
| jurisdiction      | 翻訳書出版社                         | Jpublisher                         |
| submitted         | 翻訳書出版年                         | Jyear                              |

これらの CSL の変数のどの変数がどの情報に対応しているかをいちいち参照しながら手入力で文献ファイルを用意するのは現実的ではありません。そこで Zotero のアドオンである Better BibTeX for Zotero の postscript 機能を用いて`jpa2022.csl`用の json ファイルを用意することにします。

1. Better BibTeX for Zotero の設定をします。**環境設定**から**Better BibTeX**のタブを開き，さらにその中の**Export**のタブ，**postscript**のタブを開きます。おそらく何も入力されていないと思いますので，そこにこのレポジトリの`bbtps-for-jpa2022.js`というファイルの中身をコピーアンドペーストします。これを行うことにより，エクスポート時に上の表の右列の変数名で入力された情報が CSL の変数名に置き換わります。この設定は一度行えば今後行う必要はありません。
2. 文献が日本語文献や翻訳書の場合には，Zotero の個々のアイテムの「その他」の欄に必要な情報を 1 行に 1 つずつ書いていきます。半角コロンで区切って「（上の表の）`Zotero の「その他」に入力する変数名: 必要な情報`」のように書きます。
   例えば「川上 直秋（2019）．指先が変える単語の意味――スマートフォン使用と単語の感情価の関係―― 心理学研究， _91_(1), 23-­33. [https://doi.org/10.4992/jjpsy.91.18060](https://doi.org/10.4992/jjpsy.91.18060)」を引用したい場合には「その他」欄に以下のような情報を書き加えます。

   ```
   citation key: kawakami2019
   yomi: Kawakami, Naoaki
   ```

   `citation key`の行はjpa2022.cslの処理とは直接は関係しないのですが，日本語文献を原稿ファイルで引用するときに用いるので，ここで自分にとって分かりやすい名前を設定しておくことをお勧めします。ここでは著者名と出版年にしてあります。2 行目の`yomi`の行がjpa2022.cslで用いられる著者の読みの情報です。名前については`性, 名`と半角カンマで区切って入力します。
   別の例として「Lopez-Corvo, R. E. (2009). The Woman Within: A Psychoanalytic Essay on Femininity. Routledge. （ロペス-コルヴォ，R. E.　井上 果子（監訳）飯野 晴子・赤木 里奈・山田 一子（訳）（2014）．内なる女性 ── 女性性に関する精神分析的小論 ── 　星和書店）」を引用したい場合を示します。

   ```
   Jkanyaku: 井上, 果子
   Jauthor: 飯野, 晴子 and 赤木, 里奈 and 山田, 一子
   Jyear: 2014
   Jtitle: 内なる女性──女性性に関する精神分析的小論──
   Jpublisher: 星和書店
   genchoKANA: ロペス-コルヴォ, R. E.
   ```

   複数名いる場合は「and」でつなぎます。なお，ここで用いている変数の名前については小杉考司先生が作成した[jecon_jpa.bst](https://kosugitti.github.io/jecon_jpa/)や`jpa_cite`で用いられているものを踏襲しました（参考：[jpa_cite に合った Bib ファイルの作り方](https://qiita.com/kosugitti/items/63140ead7942d4e9b1d7)）。変数名については「Jkanyaku」でも「JKANYAKU」でも「JkAnYaKu」でも動きます。

3. 文献リストを作成したいアイテムを複数選択した状態で**右クリック**（またはZoteroのコレクションを選択して右クリック），**選択されたアイテムをエクスポート**を選びます。フォーマットを選択する画面が出てきますので，「**Better CSL JSON**」を選んでOKを押し，保存先のディレクトリを選べばjsonファイルの準備は完了です。ファイルを開いてCSLの変数名に必要な情報が含まれていることを確認してください。

文献の種類ごと入力方法の細かい説明はマニュアル（準備中）を参考にしてください。

## 出力フォーマット別のやや細かい説明

### PDF ファイル

Pandocで以下のようなコマンドを用いるとLaTeXを用いてPDFファイルが生成できます。適切な表示を得るためには，いくつかオプションをつける必要があります。

```
pandoc sample2.md -o sample2.pdf --pdf-engine=lualatex -V documentclass=ltjsarticle --wrap=preserve --template=mytemplate.tex --citeproc --bibliography=sample2.json --csl=jpa2022.csl --lua-filter=modify-bibrecord.lua
```

- LaTeXエンジンは`lualatex`を選んでください。`--pdf-engine=lualatex`のオプションを加えます。`xelatex`は和文間のスペースが無視されてしまうので日本語文献の性名の間のスペースが消えます。また日本語のフォントを用いるために`-V documentclass=ltjsarticle`をつけてください。
- `--wrap=preserve`のオプションをつけてください。原因はよく分かっていないのですが`citeproc`が文献を処理するときにこのオプションをつけないと多くの日本語文献で，性と名の間のスペースの一部が改行に置き換わってしまいます。LaTeX で改行は無視されるので結果として性と名の間のスペースが消えてしまいます。
- `templates`フォルダにある`mytemplate.tex`のファイルを同じフォルダ内に置き`--template=mytemplate.tex`のオプションをつけてください。このテンプレートはPandocのデフォルトのテンプレートの関数を一部書き換えてあります。`jpa2022.csl`では，普通の文献と，改行を含む翻訳書の表示をCSLの`display="block"`と`display="indent"`という属性でコントロールしているのですが，デフォルトのテンプレートではLaTeXに変換されるときに CSL のブロックの後に改行が入ってしまう仕様になっており，もともとある改行と組み合わさって，文献リストに改行が 2 つ挿入されてしまいます。そこでもとのテンプレートの該当の箇所を以下のように書き換え，ブロック直後の改行指示`\break`を翻訳書の情報を表示する直前に移動しています（合わせてインデント幅を全角 2 文字分に変更してあります）。
  ```latex
  $if(csl-refs)$
  \newlength{\cslhangindent}
  \setlength{\cslhangindent}{2\zw}
  \newlength{\csllabelwidth}
  \setlength{\csllabelwidth}{3em}
  \newlength{\cslentryspacingunit} % times entry-spacing
  \setlength{\cslentryspacingunit}{\parskip}
  \newenvironment{CSLReferences}[2] % #1 hanging-ident, #2 entry spacing
  {% don't indent paragraphs
  \setlength{\parindent}{0pt}
  % turn on hanging indent if param 1 is 1
  \ifodd #1
  \let\oldpar\par
  \def\par{\hangindent=\cslhangindent\oldpar}
  \fi
  % set entry spacing
  \setlength{\parskip}{#2\cslentryspacingunit}
  }%
  {}
  \usepackage{calc}
  \newcommand{\CSLBlock}[1]{#1\hfill}
  \newcommand{\CSLLeftMargin}[1]{\parbox[t]{\csllabelwidth}{#1}}
  \newcommand{\CSLRightInline}[1]{\parbox[t]{\linewidth - \csllabelwidth}{#1}\break}
  \newcommand{\CSLIndent}[1]{\break\hspace{\cslhangindent}#1}
  $endif$
  ```
  独自のテンプレートを用いてPDFを作成する場合は，CSLの文献処理の箇所を上のように書き換えてもらうと不要な改行がなくなると思います。
- `modify-bibrecord.lua`を同じフォルダに置いてPandocを実行するときに`--lua-filter=modify-bibrecord.lua`のようにオプションとして指定してください。原因をいまいち理解していない部分もあるのですが，Pandocで（documentclassをltjsarticle にして）直接PDFを出力する際に以下の問題が生じます（上 2 つの問題は一度`tex`ファイルにしてから，そのファイルをコンパイルした場合は生じません）。

  - ページ区切りに使われているenダッシュ`–`（U+2013）の間に不要なスペースが挿入されてしまう。
  - `'`（U+0027）が`’`（U+2019）に置き換わり不要なアキが挿入されてしまう。
  - 日本語文献の一部で文献と文献の間に全角スペースを含めているが，行頭に来た場合にインデント＋1文字インデントされているように見えてしまう。

  これらの問題を避けるために，Pandocによる変換の途中でそれぞれを`--`，`'`，`\hspace{1\zw}`に置き換える処理を行なっています（templateをうまくいじれば解決できそうな気もするのでもし解決策が分かる方がいれば教えてください）。

### Word ファイル

Wordファイルでは一部文献リストが正確に表示されない箇所があり，手動で直していただく必要があります（Wordなので修正は簡単だと思います）。

- 翻訳書の文献リスト内での改行はWordには反映されないようなので，手動で追加してもらう必要があります。
- PandocのデフォルトのWordテンプレートでは，句読点や引用句などの役物が続いたときに字間調整が設定されません。例えば全角かっことじと全角ピリオドが続いた場合（「）．」）にはスペースが大きいので美しくありません。これはWordの**フォント**の**詳細設定**でカーニングを行うように設定すると調整することができます。※ただ，私の環境（Word for Mac ver.16.70）では日英どちらにもカーニングを行うような設定ではうまく役物の字間が調整されず，日本語フォントに対してのみカーニングを行うように設定すると字間が調整されました。
- `--reference-doc=<yourtemplate.docx>`のようにオプションを与えると自分で設定したテンプレートを使うことができます。
- `remove-unnecessary-spaces.lua`を同じフォルダ内に置きPandocを実行するときに`--lua-filter=remove-unnecessary-spaces.lua`のようにオプションとして指定してください。markdownの文中で文献キーを用いる際には前後にスペースを入れる必要がありますが，wordファイルにこのスペースが残ってしまうので，それを消すための処理を間に挟むことができます。また，CSLの仕様（？）で「et al.」の前後には必ずスペースが入ってしまうようなのですが，日本語文献の「他」の場合には不要なのでそれらを取り除く処理を含めています。

## ライセンス

`jpa2022.csl`については改変元の`apa.csl`と同じCreative Commons Attribution-ShareAlike 3.0 Licenseです。
`templates`フォルダ内の`mytemplate.tex`については改変元（[PandocのTemplatesのオリジナル](https://github.com/jgm/pandoc/blob/main/data/templates/default.latex)）と同じでGPL v2です。
その他の私が独自に作ったものについては全てMITライセンスです。

## その他

動作は以下の環境で確認しました。

- Pandoc 3.0.1
- Zotero 6.0.22
- Better bibTeX for Zotero 6.7.54
- TeX live 2022

不具合等がありましたらonoshima.t@gmail.comまで連絡ください。
