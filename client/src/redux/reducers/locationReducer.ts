
import { PayloadAction, createSlice } from "@reduxjs/toolkit";
import { SearchedLocation } from "../types/SearchedLocation";

const initialState: SearchedLocation = {
    lat: 0,
    lng: 0
}

const locationSlice = createSlice({
    name: 'location',
    initialState: initialState,
    reducers: {
        setSearchedLocation(state, action: PayloadAction<SearchedLocation>){
            console.log('setUserLocation', action.payload);
            state.lat = action.payload.lat;
            state.lng = action.payload.lng;
        }
    }
});

export const {
    setSearchedLocation
} = locationSlice.actions;

export default locationSlice.reducer;