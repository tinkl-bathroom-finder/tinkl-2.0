import React from "react";

export const AboutScreen: React.FC = () => {
    return (
        <div>
            <h1 className="wiggle" id="about-header">Did you know?</h1>
            <h5 className="about">
                Nearly <strong>60%</strong> of trans Americans have avoided using public bathrooms in
                the last year.
            </h5>

            <div id="need-to-pee">
                <img src="https://cdn4.iconfinder.com/data/icons/person-actions/227/person-action-006-512.png" />
            </div>
            <h5 className="about">
                tinkl is a bathroom-finder app that <strong>locates nearby gender-neutral and
                    single-stall bathrooms</strong> so that trans, nonbinary and gender
                non-conforming people can <strong>pee in peace</strong>.
            </h5>
        </div>
    )
}