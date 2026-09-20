import { Router } from 'express';
import { getDashboardStats, getAllUsers } from '../controllers/adminController';
import { authenticate, authorize } from '../middleware/auth';

const router = Router();

router.get('/dashboard', authenticate, authorize('ADMIN'), getDashboardStats);
router.get('/users', authenticate, authorize('ADMIN'), getAllUsers);

export default router;
