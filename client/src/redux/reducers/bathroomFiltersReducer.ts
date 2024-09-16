import { createSlice } from "@reduxjs/toolkit";

//Type
import { BathroomFilters } from "../types/BathroomFilters"

const initialState: BathroomFilters = {
    open: false,
    public: false,
    accessible: false,
    changingTable: false,
}

const bathroomFiltersSlice = createSlice({
    name: 'filters',
    initialState: initialState,
    reducers: {
        toggleOpen(state) {
            state.open = !state.open;
        },
        togglePublic(state) {
            state.public = !state.public;
        },
        toggleAccessible(state) {
            state.accessible = !state.accessible;
        },
        toggleChangingTable(state) {
            state.changingTable = !state.changingTable;
        },
    }
})

export const {
    toggleOpen,
    togglePublic,
    toggleAccessible,
    toggleChangingTable,
} = bathroomFiltersSlice.actions;

export default bathroomFiltersSlice.reducer;