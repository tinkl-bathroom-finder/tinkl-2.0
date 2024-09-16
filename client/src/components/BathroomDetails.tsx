import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { BathroomType } from "../redux/types/BathroomType";

interface BathroomDetailsProps {
    bathroom: BathroomType
}

export const BathroomDetails: React.FC<BathroomDetailsProps> = ({bathroom}) => {
    console.log("We're in the BathroomDetails component!")
    return (
        <div className="aboutContainer">
            <h1 className="aboutText">Here it is!</h1>
            <h2>{bathroom.name}</h2>
        </div>
    )
}