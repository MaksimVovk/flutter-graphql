const {
  GraphQLObjectType,
  GraphQLID,
  GraphQLString,
  GraphQLInt,
  GraphQLSchema,
} = require('graphql')

// Create types

const users = [
  { id:'1', name: 'Bill', age:20 },
  { id:'2', name: 'Samantha', age:21 }
];

const UserType = new GraphQLObjectType({
  name: 'User',
  description: 'Documentation for user',
  fields: () => ({
    id: { type: GraphQLString },
    name: { type: GraphQLString },
    age: { type: GraphQLInt },
  })
})

// RootQuery

const RootQuery = new GraphQLObjectType({
  name: 'RootQueryType',
  description: 'Description',
  fields: {
    user: {
      type: UserType,
      args: {
        id: { type: GraphQLString },
      },
      resolve(parent, args) {
        return users.find(f => f.id === args.id)
      },
    }
  }
})

module.exports = new GraphQLSchema({
  query: RootQuery,
})