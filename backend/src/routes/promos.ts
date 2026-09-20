import { Router } from 'express';
import { getPromoCodes, validatePromoCode, createPromoCode } from '../controllers/promoController';
import { authenticate, authorize } from '../middleware/auth';

const router = Router();

router.get('/', getPromoCodes);
router.post('/validate', authenticate, validatePromoCode);
router.post('/', authenticate, authorize('ADMIN'), createPromoCode);

export default router;
