const express = require('express')
const { graphqlHTTP } = require('express-graphql')
const mongoose = require('mongoose')

const schema = require('./schema/schema')
const typesShcema = require('./schema/types_schema')

const app = express()
const port = process.env.PORT || 4000

app.use('/graphql', graphqlHTTP({
  schema: typesShcema,
  graphiql: true,
}))

mongoose.connect(`
  mongodb+srv://${process.env.mongoUserName}:${process.env.mongoUserPassword}@cluster0.f65nx.mongodb.net/${process.env.mongoDatabase}?retryWrites=true&w=majority
`, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => {
  app.listen({ port: port }, () => {
    console.log('Listenign for reuest on port ' + port)
  })
}).catch(e => {
  console.error('Error: ', e)
})
