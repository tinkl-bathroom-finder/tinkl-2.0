import { configureStore, combineReducers } from "@reduxjs/toolkit";

//Reducers
import userSlice from './reducers/userReducer';
import bathroomSlice from './reducers/bathroomReducer';

// import { TinklRootState } from "./types/TinklRootState"; //Should only be needed if persistent state is set up

const allReducers = combineReducers({
    bathroomData: bathroomSlice,
    user: userSlice
});

const storeInstance = configureStore({
    reducer: allReducers,
    middleware: (getDefaultMiddleware) =>
        getDefaultMiddleware({
            serializableCheck: false,
        }),
});

export { storeInstance };
export type AppDispatch = typeof storeInstance.dispatch;
