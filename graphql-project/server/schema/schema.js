const {
  GraphQLObjectType,
  GraphQLID,
  GraphQLString,
  GraphQLInt,
  GraphQLSchema,
} = require('graphql')

// Create types

const usersData = [
  { id:'1', name: 'Bill', age: 20, profession: 'Developer' },
  { id:'2', name: 'Samantha', age: 21, profession: 'Teacher' },
  { id:'3', name: 'Anton', age: 15, profession: 'Student' },
  { id:'4', name: 'Dima', age: 37, profession: 'PM' },
  { id:'5', name: 'Alice', age: 39, profession: 'Doctor' },
];

const hobbiesData = [
  { id:'1', title: 'Sports', description: 'Play any sport games like a football' },
  { id:'2', title: 'Video Games', description: 'Play any computer game like a CS go' },
  { id:'3', title: 'Programming', description: 'Use computer to make the world a better' },
  { id:'4', title: 'Reading Books', description: 'Read any an interesting books' },
  { id:'5', title: 'Tech Blog', description: 'Make an interesting blog about modern technologies' },
]

const UserType = new GraphQLObjectType({
  name: 'User',
  description: 'Documentation for user',
  fields: () => ({
    id: { type: GraphQLID },
    name: { type: GraphQLString },
    age: { type: GraphQLInt },
    profession: { type: GraphQLString },
  })
})

const HobbyType = new GraphQLObjectType({
  name: 'Hobby',
  description: 'Hobby description',
  fields: () => ({
    id: { type: GraphQLID },
    title: { type: GraphQLString },
    description: { type: GraphQLString },
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
        id: { type: GraphQLID },
      },
      resolve(parent, args) {
        const { id } = args
        return usersData.find(f => f.id === id)
      },
    },
    hobby: {
      type: HobbyType,
      args: {
        id: { type: GraphQLID },
      },
      resolve (parent, args) {
        const { id } = args
        return hobbiesData.find(f => f.id === id)
      }
    }
  }
})

module.exports = new GraphQLSchema({
  query: RootQuery,
})