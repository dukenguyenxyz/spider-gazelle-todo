# Spider-Gazelle To-do App

## Documentation

### Routes

|get | /tasks/ |TasksController#index |
|get | /tasks/:id | TasksController#show |
|post | /tasks/ |TasksController#create |
|patch | /tasks/:id | TasksController#update |
|delete | /tasks/:id | TasksController#destroy |

## Running in Local Environment

- to run in development mode `crystal ./src/app.cr`

- to run in watch mode
  - install node.js
  - install nodemon `npm i -g nodemon`
  - execute the following command `nodemon --exec crystal ./src/app.cr`

## Testing

- to run all tests `crystal spec`
- to watch all tests during edits `nodemon --exec crystal spec`

## Compiling

`crystal build ./src/app.cr`

### Deploying

Once compiled you are left with a binary `./app`

- for help `./app --help`
- viewing routes `./app --routes`
- run on a different port or host `./app -b 0.0.0.0 -p 80`
