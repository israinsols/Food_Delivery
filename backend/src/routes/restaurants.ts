import { Router } from 'express';
import { getAllRestaurants, getRestaurantById, createRestaurant, updateRestaurant, deleteRestaurant, toggleRestaurantOpen } from '../controllers/restaurantController';
import { authenticate, authorize } from '../middleware/auth';

const router = Router();

router.get('/', getAllRestaurants);
router.get('/:id', getRestaurantById);
router.post('/', authenticate, authorize('VENDOR', 'ADMIN'), createRestaurant);
router.put('/:id', authenticate, authorize('VENDOR', 'ADMIN'), updateRestaurant);
router.delete('/:id', authenticate, authorize('VENDOR', 'ADMIN'), deleteRestaurant);
router.patch('/:id/toggle-open', authenticate, authorize('VENDOR', 'ADMIN'), toggleRestaurantOpen);

export default router;
