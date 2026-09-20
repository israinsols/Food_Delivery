import { Router } from 'express';
import { getAddresses, createAddress, deleteAddress } from '../controllers/userController';
import { authenticate } from '../middleware/auth';

const router = Router();

router.get('/addresses', authenticate, getAddresses);
router.post('/addresses', authenticate, createAddress);
router.delete('/addresses/:id', authenticate, deleteAddress);

export default router;
