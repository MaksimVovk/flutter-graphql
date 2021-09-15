const {
  GraphQLObjectType,
  GraphQLID,
  GraphQLString,
  GraphQLInt,
  GraphQLSchema,
} = require('graphql')

// Create types

const usersData = [
  { id:'1', name: 'Bill', age: 20 },
  { id:'2', name: 'Samantha', age: 21 },
  { id:'3', name: 'Anton', age: 15 },
  { id:'4', name: 'Dima', age: 37 },
  { id:'5', name: 'Alice', age: 39 },
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
        const { id } = args
        return usersData.find(f => f.id === id)
      },
    }
  }
})

module.exports = new GraphQLSchema({
  query: RootQuery,
})