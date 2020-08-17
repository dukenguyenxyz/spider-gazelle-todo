# Spider-Gazelle To-do App

## Documentation

### Routes

| Method | Path | Controller Actions      |
| ------ | ---- | ----------------------- |
| get    | /    | TasksController#index   |
| get    | /:id | TasksController#show    |
| post   | /    | TasksController#create  |
| patch  | /:id | TasksController#update  |
| delete | /:id | TasksController#destroy |

### Task Resource

- Attributes
  - Title : String
  - Note : String

#### Create a task

- Send the Task object to TasksController#create
  `{ title: 'Going shopping' note: 'Brocolli, water spinach, bacon' }`

#### View a task

- Set params ID to task ID /:id/ and send to TasksController#show

#### Update a task

- Set params ID to task ID. Send single or multiple attributes of the Task
  object to TasksController#update `{ title: 'Going shopping in Parramatta' }`

#### View all tasks

- Send a request to TasksController#index

#### Delete a task

- Set params ID to task ID /:id/ and send to TasksController#destroy

### Running in Local Environment

## With Docker

- Test Environment:
  `ENV_VAR=test docker-compose up --build --exit-code-from web`
- Production Environment:
  `ENV_VAR=prod docker-compose up --build --exit-code-from web`

## Without Docker

- to run in development mode `crystal ./src/app.cr`

- to run in watch mode
  - install node.js
  - install nodemon `npm i -g nodemon`
  - execute the following command `nodemon --exec crystal ./src/app.cr`

### Testing

- to run all tests `crystal spec`
- to watch all tests during edits `nodemon --exec crystal spec`

### Compiling

`crystal build ./src/app.cr`

#### Deploying

Once compiled you are left with a binary `./app`

- for help `./app --help`
- viewing routes `./app --routes`
- run on a different port or host `./app -b 0.0.0.0 -p 80`
