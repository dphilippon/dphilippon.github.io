var lunr = require('lunr'),
    stdin = process.stdin,
    stdout = process.stdout,
    buffer = []

stdin.resume()
stdin.setEncoding('utf8')

stdin.on('data', function (data) {
  buffer.push(data)
})

stdin.on('end', function () {
	var stringify = JSON.stringify(buffer.join())
  var documents = JSON.parse(stringify)

  var idx = lunr(function () {
    this.ref('id')
    this.field('title',{ boost: 10 })
    this.field('content')

    documents.forEach(function (doc) {
      this.add(doc)
    }, this)
  })

  stdout.write(JSON.stringify(idx))
})