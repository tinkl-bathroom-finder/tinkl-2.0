import { createSlice } from "@reduxjs/toolkit";

//Type
import { TinklOptions } from "../types/TinklOptions";
import { PayloadAction } from "@reduxjs/toolkit";

const initialState: TinklOptions = {
    showAbout: false,
    showDetails: false,
    darkMode: false,
    selectedBathroomID: null
}



const tinklOptionsSlice = createSlice({
    name: 'options',
    initialState: initialState,
    reducers: {
        toggleAboutScreen(state) {
            state.showAbout = !state.showAbout;
            // state.showMainApp = !state.showMainApp;
        },
        setAboutScreen(state, action: PayloadAction<boolean>) {
            state.showAbout = action.payload;
        },
        toggleDetailsScreen(state) {
            state.showDetails = !state.showDetails;
        },
        setDetailsScreen(state, action: PayloadAction<boolean>) {
            state.showDetails = action.payload;
        },
        toggleDarkMode(state) {
            state.darkMode = !state.darkMode;
        },
        setBathroomID(state, action: PayloadAction<number>) {
            state.selectedBathroomID = action.payload;
        }
    }
});

export const {
    toggleAboutScreen,
    setAboutScreen,
    toggleDetailsScreen,
    setDetailsScreen,
    toggleDarkMode,
    setBathroomID
} = tinklOptionsSlice.actions;

export default tinklOptionsSlice.reducer;