import { Router } from 'express';
import { createOrder, getOrders, getOrderById, updateOrderStatus, estimateDeliveryFee } from '../controllers/orderController';
import { authenticate, authorize } from '../middleware/auth';

const router = Router();

router.post('/estimate-fee', authenticate, estimateDeliveryFee);
router.get('/', authenticate, getOrders);
router.get('/:id', authenticate, getOrderById);
router.post('/', authenticate, createOrder);
router.patch('/:id/status', authenticate, authorize('VENDOR', 'ADMIN', 'RIDER'), updateOrderStatus);

export default router;
