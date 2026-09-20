import { Router } from 'express';
import { getVendorDashboard } from '../controllers/vendorController';
import { authenticate, authorize } from '../middleware/auth';

const router = Router();

router.get('/dashboard', authenticate, authorize('VENDOR'), getVendorDashboard);

export default router;
