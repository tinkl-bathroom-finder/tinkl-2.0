import { configureStore, combineReducers } from "@reduxjs/toolkit";
import logger from 'redux-logger';

//Reducers
import userSlice from './reducers/userReducer';
import bathroomSlice from './reducers/bathroomReducer';
import tinklOptionsSlice from "./reducers/tinklOptionsReducer";

// import { TinklRootState } from "./types/TinklRootState"; //Should only be needed if persistent state is set up

const allReducers = combineReducers({
    bathroomData: bathroomSlice,
    user: userSlice,
    options: tinklOptionsSlice
});

const storeInstance = configureStore({
    reducer: allReducers,
    middleware: (getDefaultMiddleware) =>
        getDefaultMiddleware({
            serializableCheck: false,
        }).concat(logger),
});

export { storeInstance };
export type AppDispatch = typeof storeInstance.dispatch;
