// app/javascript/controllers/index.js

import { application } from "./application"

import HelloController from "./hello_controller"
import PaymentController from "./payment_controller"
import ChartController from "./chart_controller"

application.register("hello", HelloController)
application.register("payment", PaymentController)
application.register("chart", ChartController)
