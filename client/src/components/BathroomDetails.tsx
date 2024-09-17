import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { BathroomType } from "../redux/types/BathroomType";

import { TinklRootState } from "../redux/types/TinklRootState";

interface BathroomDetailsProps {
    bathroom: BathroomType
}

export const BathroomDetails: React.FC<BathroomDetailsProps> = ({bathroom}) => {
    const options = useSelector((state: TinklRootState) => state.options);
    const bathroomData: BathroomType[] = useSelector((state: TinklRootState) => state.bathroomData);
    const selectedBathroom = bathroomData.filter(function(br){return br.id === options.selectedBathroomID})[0]
    console.log("selectedBathroom", selectedBathroom)
    return (
        <div className="aboutContainer">
            <h1 className="aboutText">Here it is!</h1>
            <h2>{selectedBathroom.name}</h2>
            <h3>{options.selectedBathroomID}</h3>
        </div>
    )
}