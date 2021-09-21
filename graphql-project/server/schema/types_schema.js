const {
  GraphQLObjectType,
  GraphQLSchema,
  GraphQLString,
  GraphQLID,
  GraphQLInt,
  GraphQLBoolean,
  GraphQLFloat,
  GraphQLNonNull,
} = require('graphql')

// Scalar Type
/*
  String = GraphQLString
  int = GraphQLInt
  Float = GraphQLFloat
  Boolean = GraphQLBoolean
  ID = GraphQLID
*/

const Person = new GraphQLObjectType({
  name: 'Person',
  description: 'Person description',
  fields: () => ({
    id: { type: GraphQLID },
    name: { type: new GraphQLNonNull(GraphQLString) },
    age: { type: GraphQLInt },
    isMarrid: { type: GraphQLBoolean },
    gpa: { type: GraphQLFloat },

    justAType: {
      type: Person,
      resolve (parent, args) {
        return parent
      }
    }
  })

})

// RootQuery

const RootQuery = new GraphQLObjectType({
  name: 'RootQueryType',
  description: 'Description',
  fields: {
    person: {
      type: Person,
      resolve (parrent, args) {
        let person = {
          // id
          name: 'Antonio',
          age: 34,
          isMarrid: true,
          gpa: 4.0,
        }

        return person
      },
    },
  }
})

module.exports = new GraphQLSchema({
  query: RootQuery,
})