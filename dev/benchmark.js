const path = require('path');
const fs = require('fs-plus');
const GrammarRegistry = require('../lib/grammar-registry');

const registry = new GrammarRegistry();
const RakuGrammar = registry.loadGrammarSync(path.resolve(__dirname, '..', '..', 'atom-language-perl6', 'grammars', 'raku.json'));
RakuGrammar.maxTokensPerLine = Infinity;

let duration_tot = 0;
function tokenize(grammar, content, lineCount) {
  const start = Date.now();
  const {tags} = grammar.tokenizeLines(content);
  const duration = Date.now() - start;
  let tokenCount = 0;
  //tokenCount = tags.filter(tag => tag >= 0).length;
  const tokensPerMillisecond = Math.round(tokenCount / duration);
  console.log(`Generated ${tokenCount} tokens for ${lineCount} lines in ${duration}ms (${tokensPerMillisecond} tokens/ms)`);
  duration_tot += duration;
  return duration_tot;
}

function tokenizeFile(filePath, grammar, message) {
  console.log();
  console.log(message);
  const content = fs.readFileSync(filePath, 'utf8');
  const lineCount = content.split('\n').length;
  console.log(lineCount);
  return tokenize(grammar, content, lineCount); 
}

const TestFolder = path.resolve('benchmark', 'rakudo');
const files = fs.readdirSync(TestFolder);
for (file of files) {
  console.log(file);
  tokenizeFile(path.resolve('benchmark', 'rakudo', file), RakuGrammar, `tokening ${file}`); 
}

console.log(`Total time: ${duration_tot}ms`);
