import { BathroomType } from "../redux/types/BathroomType";
import { BathroomFilters } from "../redux/types/BathroomFilters";


// Function used to control the filter buttons on the primary map and the list view - returns an array of BathroomType that can be mapped 
// onto the primary map display

export const filterBathroomData = (data: BathroomType[], filters: BathroomFilters): BathroomType[] => {
    if (!filters.accessible && !filters.changingTable && !filters.open && !filters.public) return data;

    //Matches filter selection to corresponding data point on bathroom data array and returns only those matches to an array
    return data.filter((bathroom) => {
        return (
            (!filters.accessible || bathroom.accessible) &&
            (!filters.changingTable || bathroom.changing_table) &&
            (!filters.open || bathroom.is_open) &&
            (!filters.public || bathroom.public)

        );
    });
};