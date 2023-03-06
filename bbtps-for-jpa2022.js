/*
# MIT License
Copyright (c) 2023 Takahiro Onoshima

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
if (Translator.BetterCSLJSON) {
  const map = [
    { from: "yomi", to: "curator" },
    { from: "kanshu", to: "producer" },
    { from: "jkanyaku", to: "guest" },
    { from: "jtitle", to: "dimensions" },
    { from: "jauthor", to: "host" },
    { from: "genchokana", to: "compiler" },
    { from: "jpublisher", to: "jurisdiction" },
    { from: "jyear", to: "submitted" },
  ];

  function lowercaseFields(strZotExtra) {
    const arrFieldsRegexp = [
      /jkanyaku/i,
      /jyear/i,
      /jtitle/i,
      /jpublisher/i,
      /jauthor/i,
      /genchokana/i,
      /yomi/i,
      /kanshu/i,
    ];
    const arrLowerecasedFields = arrFieldsRegexp.map(function (field) {
      return field.toString().replace("/i", "").replace("/", "");
    });
    let res = strZotExtra;
    for (let i = 0; i < arrFieldsRegexp.length; i++) {
      res = res.replace(arrFieldsRegexp[i], arrLowerecasedFields[i]);
    }
    return res;
  }

  /* fieldの対応づけ関係の関数たち */
  function bibname2CSLname(strNames) {
    const eachName = strNames.split("and");
    const res = eachName.map(function (strName) {
      const arrFamilyGiven = strName.split(",");
      if (arrFamilyGiven.length == 2) {
        return {
          family: arrFamilyGiven[0].trim(),
          given: arrFamilyGiven[1].trim(),
        };
      } else {
        return { family: arrFamilyGiven[0].trim() };
      }
    });
    return res;
  }
  function mapZotToCSL(strExtrafield) {
    const splittedExtra = strExtrafield.split("\n");
    for (const eachLine of splittedExtra) {
      for (const eachMap of map) {
        if (eachLine.match(eachMap["from"])) {
          const value = eachLine.slice(
            eachLine.indexOf(":") + 1,
            eachLine.length
          );
          if (eachLine.match("yomi")) {
            csl[eachMap["to"]] = bibname2CSLname(value);
          } else if (eachLine.match("jkanyaku|jauthor|kanshu")) {
            csl[eachMap["to"]] = bibname2CSLname(value);
          } else if (eachLine.match("genchokana")) {
            csl[eachMap["to"]] = bibname2CSLname(value);
          } else if (eachLine.match("jyear")) {
            csl.submitted = { "date-parts": [[value.trim()]] };
          } else {
            csl[eachMap["to"]] = value.trim();
          }
        }
      }
    }
  }

  /* その他細々としたもの*/

  function ignoreFirstEdition() {
    if (/1|第1版|1st ed\.|1st/.test(csl.edition)) {
      delete csl.edition;
    }
  }
  function supressURLexport() {
    if (csl.type !== "webpage") {
      delete csl.URL;
    }
  }

  /* メインの処理*/
  const lowercasedZotExtra = lowercaseFields(zotero.extra);
  mapZotToCSL(lowercasedZotExtra);

  /* その他の細々とした処理*/
  ignoreFirstEdition();
  supressURLexport();
}
