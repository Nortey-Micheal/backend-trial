import { Router } from "express";
import { cancelScheduledTransfer, createScheduledTransfer, getScheduledTransfer, modifycheduledTransfer, pauseScheduledTransfer, viewScheduledTransfer } from "../../controllers/scheduled-transfers/scheduled_transfers.controller.js";

const scheduledTransfersRoutes = Router()

scheduledTransfersRoutes.post('/',createScheduledTransfer )
scheduledTransfersRoutes.get('/', getScheduledTransfer)
scheduledTransfersRoutes.patch('/:id', modifycheduledTransfer)
scheduledTransfersRoutes.patch('/pause/:id', pauseScheduledTransfer)
scheduledTransfersRoutes.post('/:id/cancel', cancelScheduledTransfer)
scheduledTransfersRoutes.get('/:id/attempts', viewScheduledTransfer)

export default scheduledTransfersRoutes