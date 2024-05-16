import { Application } from "@hotwired/stimulus"
import HelloController from "./hello_controller"
import PaymentController from "./payment_controller"

const application = Application.start()
application.register("hello", HelloController)
application.register("payment", PaymentController)
