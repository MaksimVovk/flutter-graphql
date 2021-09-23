const {
  GraphQLObjectType,
  GraphQLID,
  GraphQLString,
  GraphQLInt,
  GraphQLSchema,
  GraphQLList,
  GraphQLNonNull,
} = require('graphql')

const {
  User,
  Post,
  Hobby
} = require('../model')


// dummy data
/* const usersData = [
  { id:'1', name: 'Bill', age: 20, profession: 'Developer' },
  { id:'2', name: 'Samantha', age: 21, profession: 'Teacher' },
  { id:'3', name: 'Anton', age: 15, profession: 'Student' },
  { id:'4', name: 'Dima', age: 37, profession: 'PM' },
  { id:'5', name: 'Alice', age: 39, profession: 'Doctor' },
];

const hobbiesData = [
  { id: '1', userId: '4', title: 'Sports', description: 'Play any sport games like a football' },
  { id: '2', userId: '1', title: 'Video Games', description: 'Play any computer game like a CS go' },
  { id: '3', userId: '1', title: 'Programming', description: 'Use computer to make the world a better' },
  { id: '4', userId: '3', title: 'Reading Books', description: 'Read any an interesting books' },
  { id: '5', userId: '2', title: 'Tech Blog', description: 'Make an interesting blog about modern technologies' },
]

const postsData = [
  { id: '1', userId: '4', comment: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.' },
  { id: '2', userId: '1', comment: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.' },
  { id: '3', userId: '1', comment: 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.' },
  { id: '4', userId: '3', comment: 'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' },
  { id: '5', userId: '2', comment: 'Lorem ipsum dolor sit amet.' },
]
*/

// Create types
const UserType = new GraphQLObjectType({
  name: 'User',
  description: 'Documentation for user',
  fields: () => ({
    id: { type: GraphQLID },
    name: { type: GraphQLString },
    age: { type: GraphQLInt },
    profession: { type: GraphQLString },
    posts: {
      type: new GraphQLList(PostType),
      resolve (parent, args) {
        return Post.find({ userId: parent.id })
      },
    },
    hobbies: {
      type: new GraphQLList(HobbyType),
      resolve (parent, args) {
        return Hobby.find({ userId: parent.id })
      },
    }
  })
})

const HobbyType = new GraphQLObjectType({
  name: 'Hobby',
  description: 'Hobby description',
  fields: () => ({
    id: { type: GraphQLID },
    title: { type: GraphQLString },
    description: { type: GraphQLString },
    user: {
      type: UserType,
      resolve (parent, args) {
        return User.findById(parent.userId)
      }
    }
  })
})

const PostType = new GraphQLObjectType({
  name: 'Post',
  description: 'Post description',
  fields: () => ({
    id: { type: GraphQLID },
    comment: { type: GraphQLString },
    user: {
      type: UserType,
      resolve (parent, args) {
        return User.findById(parent.userId)
      }
    }
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
        return User.findById(id)
      },
    },
    users : {
      type: new GraphQLList(UserType),
      args: {
        ids: { type: GraphQLList(GraphQLID)}
      },
      resolve (parent, args) {
        return User.find({})
      }
    },
    hobby: {
      type: HobbyType,
      args: {
        id: { type: GraphQLID },
      },
      resolve (parent, args) {
        const { id } = args
        return Hobby.findById(id)
      }
    },
    hobbies: {
      type: new GraphQLList(HobbyType),
      resolve (parent, args) {
        return Hobby.find({})
      }
    },
    post: {
      type: PostType,
      args: {
        id: { type: GraphQLID, require: false },
        search: { type: GraphQLString, require: false },
      },
      resolve (parent, args) {
        const id = args && args.id
        const search = args && args.search

        return Post.findById(id)
      }
    },
    posts: {
      type: new GraphQLList(PostType),
      resolve (parent, args) {
        return Post.find({})
      }
    },
  }
})

// Mutations

const Mutation = new GraphQLObjectType({
  name: 'Mutation',
  fields: {
    CreateUser: {
      type: UserType,
      args: {
        // id: { type: GraphQLID },
        name: { type: GraphQLNonNull(GraphQLString) },
        age: { type: GraphQLNonNull(GraphQLInt) },
        profession: { type: GraphQLString },
      },
      resolve (parent, args) {
        const user = User({
          name: args.name,
          age: args.age,
          profession: args.profession,
        })

        return user.save()
      }
    },
    UpdateUser: {
      type: UserType,
      args: {
        id: { type: GraphQLNonNull(GraphQLString) },
        name: { type: GraphQLNonNull(GraphQLString) },
        age: { type: GraphQLNonNull(GraphQLInt) },
        profession: { type: GraphQLString },
      },
      resolve (parent, args) {
        return (updateUser = User.findByIdAndUpdate(
          args.id,
          {
            $set: {
              name: args.name,
              age: args.age,
              profession: args.profession,
            }
          },
          { new: true },
        ))
      }
    },
    RemoveUser: {
      type: UserType,
      args: {
        id: { type: GraphQLNonNull(GraphQLString) },
      },
      resolve (parent, args) {
        const removedUser = User.findByIdAndRemove(args.id).exec()

        if (!removedUser) {
          throw new Error()
        }

        return removedUser
      }
    },
    CreatePost: {
      type: PostType,
      args: {
        // id: { type: GraphQLID },
        comment: { type: GraphQLNonNull(GraphQLString) },
        userId: { type: GraphQLNonNull(GraphQLID) },
      },
      resolve (parent, args) {
        const post = Post({
          comment: args.comment,
          userId: args.userId,
        })

        return post.save()
      }
    },
    UpdatePost: {
      type: PostType,
      args: {
        id: { type: GraphQLNonNull(GraphQLID) },
        comment: { type: GraphQLNonNull(GraphQLString) },
      },
      resolve (parent, args) {
        return Post.findOneAndUpdate(
          args.id,
          {
            $set: {
              comment: args.comment,
            },
          },
          { new: true },
        )
      }
    },
    CreateHobby: {
      type: HobbyType,
      args: {
        // id: { type: GraphQLID },
        title: { type: GraphQLNonNull(GraphQLString) },
        description: { type: GraphQLNonNull(GraphQLString) },
        userId: { type: GraphQLNonNull(GraphQLID) },
      },
      resolve (parent, args) {
        const hobby = Hobby({
          title: args.title,
          description: args.description,
          userId: args.userId,
        })

        return hobby.save()
      }
    },
    UpdateHobby: {
      type: HobbyType,
      args: {
        id: { type: GraphQLNonNull(GraphQLID) },
        title: { type: GraphQLNonNull(GraphQLString) },
        description: { type: GraphQLNonNull(GraphQLString) },
      },
      resolve (parent, args) {
        return Hobby.findOneAndUpdate(
          args.id,
          {
            $set: {
              title: args.title,
              description: args.description,
            }
          }, { new: true }
        )
      }
    }
  }
})

module.exports = new GraphQLSchema({
  query: RootQuery,
  mutation: Mutation,
})