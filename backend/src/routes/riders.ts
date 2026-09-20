import { Router } from 'express';
import { getRiders, createRiderProfile, updateRiderLocation, toggleRiderAvailability } from '../controllers/riderController';
import { authenticate, authorize } from '../middleware/auth';

const router = Router();

router.get('/', authenticate, authorize('ADMIN'), getRiders);
router.post('/', authenticate, createRiderProfile);
router.patch('/location', authenticate, authorize('RIDER'), updateRiderLocation);
router.patch('/toggle-availability', authenticate, authorize('RIDER'), toggleRiderAvailability);

export default router;
