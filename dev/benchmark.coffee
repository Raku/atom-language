path = require 'path'
fs = require 'fs-plus'
GrammarRegistry = require '../lib/grammar-registry'

registry = new GrammarRegistry()
p6Grammar = registry.loadGrammarSync(path.resolve(__dirname, '..', '..', 'atom-language-perl6', 'grammars', 'perl6fe.cson'))
p6Grammar.maxTokensPerLine = Infinity

duration_tot = 0
tokenize = (grammar, content, lineCount) ->
  start = Date.now()
  {tags} = grammar.tokenizeLines(content)
  duration = Date.now() - start
  tokenCount = 0
  #tokenCount++ for tag in tags when tag >= 0
  tokensPerMillisecond = Math.round(tokenCount / duration)
  console.log "Generated #{tokenCount} tokens for #{lineCount} lines in #{duration}ms (#{tokensPerMillisecond} tokens/ms)"
  duration_tot = duration_tot + duration

tokenizeFile = (filePath, grammar, message) ->
  console.log()
  console.log(message)
  content = fs.readFileSync(filePath, 'utf8')
  lineCount = content.split('\n').length
  console.log lineCount
  tokenize(grammar, content, lineCount)

TestFolder = path.resolve('benchmark', 'rakudo')
files = fs.readdirSync(TestFolder)
for file in files
  console.log file
  tokenizeFile(path.resolve('benchmark', 'rakudo', file), p6Grammar, "tokening #{file}")

console.log "Total time: #{duration_tot}ms"
